from datetime import datetime

import backtrader as bt
import MetaTrader5 as mt5
import pandas as pd

# Initialize MT5
if not mt5.initialize():
    print("MT5 initialization failed")
    exit()

# Check terminal connection
if not mt5.terminal_info():
    print("MT5 terminal not connected")
    mt5.shutdown()
    exit()

# Define parameters
symbol = "XAUUSD"
timeframe = mt5.TIMEFRAME_H1

# Check symbol availability
if not mt5.symbol_select(symbol, True):
    print(f"Symbol {symbol} not available")
    mt5.shutdown()
    exit()
from_date = datetime(2024, 6, 1)
to_date = datetime(2024, 12, 1)

# Fetch historical data
rates = mt5.copy_rates_range(symbol, timeframe, from_date, to_date)
if rates is None or len(rates) == 0:
    print("No data retrieved")
    mt5.shutdown()
    exit()

# Convert to pandas DataFrame
df = pd.DataFrame(rates)
print(f"Retrieved {len(rates)} bars")
df["time"] = pd.to_datetime(df["time"], unit="s")
df.set_index("time", inplace=True)
df = df[["open", "high", "low", "close", "tick_volume"]]
df.columns = ["open", "high", "low", "close", "volume"]


# Define the strategy
class EA_AK47Hybrid(bt.Strategy):
    params = (
        ("rsi_period", 14),
        ("ema_period", 21),
        ("rsi_oversold", 35),
        ("rsi_overbought", 65),
        ("atr_period", 14),
        ("min_atr", 0.0),
        ("macd_fast", 12),
        ("macd_slow", 26),
        ("macd_signal", 9),
        ("use_macd_filter", True),
        ("sma_fast", 10),
        ("sma_slow", 20),
        ("stop_loss", 30),  # Reduced SL to capture more trades
        ("take_profit", 180),  # Increased TP for better R:R
        ("martingale_multiplier", 1.0),  # Disable Martingale
        ("max_martingale_levels", 0),
    )

    def __init__(self):
        self.rsi = bt.indicators.RSI(self.data.close, period=self.params.rsi_period)
        self.ema = bt.indicators.EMA(self.data.close, period=self.params.ema_period)
        self.atr = bt.indicators.ATR(self.data, period=self.params.atr_period)
        self.macd = bt.indicators.MACD(
            self.data.close,
            period_me1=self.params.macd_fast,
            period_me2=self.params.macd_slow,
            period_signal=self.params.macd_signal,
        )
        self.sma_fast = bt.indicators.SMA(self.data.close, period=self.params.sma_fast)
        self.sma_slow = bt.indicators.SMA(self.data.close, period=self.params.sma_slow)
        self.buy_signals = 0
        self.sell_signals = 0
        self.consecutive_losses = 0
        self.current_lot = 1.0  # Stake multiplier

    def next(self):
        if not self.position:
            # Check ATR filter (require current ATR above minimum)
            # use the latest ATR value
            if self.atr[0] < self.params.min_atr:
                return
            # Prepare MACD conditions (use current bar values)
            macd_bull = self.macd.macd[0] > self.macd.signal[0]
            macd_bear = self.macd.macd[0] < self.macd.signal[0]
            # Buy signal: RSI oversold or bullish MA crossover (MACD optional filter)
            if (
                self.rsi < self.params.rsi_oversold
                or (
                    self.sma_fast[-1] <= self.sma_slow[-1]
                    and self.sma_fast[0] > self.sma_slow[0]
                )
            ) and (
                not hasattr(self.params, "use_macd_filter")
                or not self.params.use_macd_filter
                or macd_bull
            ):
                self.buy_signals += 1
                self.buy(size=self.current_lot)
            # Sell signal: RSI overbought or bearish MA crossover (MACD optional filter)
            elif (
                self.rsi > self.params.rsi_overbought
                or (
                    self.sma_fast[-1] >= self.sma_slow[-1]
                    and self.sma_fast[0] < self.sma_slow[0]
                )
            ) and (
                not hasattr(self.params, "use_macd_filter")
                or not self.params.use_macd_filter
                or macd_bear
            ):
                self.sell_signals += 1
                self.sell(size=self.current_lot)
        else:
            # Check for exit
            if self.position.size > 0:  # Long position
                # Check take profit or stop loss
                if (
                    self.data.close
                    >= self.position.price + self.params.take_profit * self.data._point
                    or self.data.close
                    <= self.position.price - self.params.stop_loss * self.data._point
                ):
                    self.close()
                    # Update martingale
                    if (
                        self.data.close
                        <= self.position.price
                        - self.params.stop_loss * self.data._point
                    ):
                        self.consecutive_losses += 1
                        if self.consecutive_losses <= self.params.max_martingale_levels:
                            self.current_lot *= self.params.martingale_multiplier
                        else:
                            self.consecutive_losses = 0
                            self.current_lot = 1.0
                    else:
                        self.consecutive_losses = 0
                        self.current_lot = 1.0
            elif self.position.size < 0:  # Short position
                if (
                    self.data.close
                    <= self.position.price - self.params.take_profit * self.data._point
                    or self.data.close
                    >= self.position.price + self.params.stop_loss * self.data._point
                ):
                    self.close()
                    # Update martingale
                    if (
                        self.data.close
                        >= self.position.price
                        + self.params.stop_loss * self.data._point
                    ):
                        self.consecutive_losses += 1
                        if self.consecutive_losses <= self.params.max_martingale_levels:
                            self.current_lot *= self.params.martingale_multiplier
                        else:
                            self.consecutive_losses = 0
                            self.current_lot = 1.0
                    else:
                        self.consecutive_losses = 0
                        self.current_lot = 1.0


# Set up Backtrader
cerebro = bt.Cerebro()
data = bt.feeds.PandasData(dataname=df)
data._point = 0.01  # Set point to 0.01 for XAUUSD (gold pips)
cerebro.adddata(data)
cerebro.addstrategy(EA_AK47Hybrid)

# Add analyzers for statistics
cerebro.addanalyzer(bt.analyzers.SharpeRatio, _name="sharpe")
cerebro.addanalyzer(bt.analyzers.DrawDown, _name="drawdown")
cerebro.addanalyzer(bt.analyzers.Returns, _name="returns")

# Broker settings
cerebro.broker.setcash(500.0)
cerebro.addsizer(
    bt.sizers.FixedSize, stake=0.05
)  # Base stake for 0.05 lots, no martingale

# Run backtest
print("Running backtest...")
results = cerebro.run()
strat = results[0]
print("Buy signals: %d" % strat.buy_signals)
print("Sell signals: %d" % strat.sell_signals)
print("Final Portfolio Value: %.2f" % cerebro.broker.getvalue())

# Print analyzer results
sharpe = strat.analyzers.sharpe.get_analysis()
sharpe_val = sharpe.get("sharperatio")
if sharpe_val is not None:
    print("Sharpe Ratio: %.2f" % sharpe_val)
else:
    print("Sharpe Ratio: N/A")

drawdown = strat.analyzers.drawdown.get_analysis()
max_dd = drawdown.get("max", {}).get("drawdown", 0)
print("Max Drawdown: %.2f%%" % max_dd)

returns = strat.analyzers.returns.get_analysis()
total_ret = returns.get("rtot", 0) * 100
print("Total Return: %.2f%%" % total_ret)

# Plot results
cerebro.plot()

# Shutdown MT5
mt5.shutdown()
