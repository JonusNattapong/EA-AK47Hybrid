# EA-AK47Hybrid

## Description

EA-AK47Hybrid is a modular Expert Advisor (EA) designed for MetaTrader 5, implementing a long-term scalping strategy based on the Relative Strength Index (RSI) indicator and EMA trend filter. This EA aims to capitalize on price movements by entering and exiting trades quickly while following the long-term trend.

The EA features a **modular architecture** with separate components for indicators, trading, signals, and risk management, making it easy to maintain, extend, and customize.

## Modular Architecture

The EA is organized into the following modules (located in the `Include` folder):

### 1. **IndicatorManager.mqh**
Manages all technical indicators used by the EA.
- Handles RSI and EMA indicators
- Provides methods to check overbought/oversold conditions
- Manages price position relative to EMA

### 2. **TradeManager.mqh**
Handles all trade execution and position management.
- Opens buy/sell positions with proper SL/TP
- Closes positions individually or all at once
- Checks for existing positions
- Normalizes prices and lot sizes

### 3. **SignalManager.mqh**
Generates trading signals based on indicator data.
- Combines RSI and EMA signals
- Provides buy/sell signal detection
- Configurable trend filter on/off

### 4. **RiskManager.mqh**
Manages risk and position sizing.
- Fixed lot size mode
- Risk-based position sizing (percentage of account)
- Margin checking before opening trades
- Lot normalization based on broker requirements

### 5. **TrailingStopManager.mqh**
Manages dynamic trailing stop functionality.
- Fixed, percentage-based, or ATR-based trailing modes
- Automatic stop loss adjustment as price moves favorably
- Configurable trailing distance and step size

### 6. **BreakevenManager.mqh**
Handles automatic breakeven moves.
- Moves stop loss to breakeven once profit target is reached
- Optional offset from entry price
- Prevents losses on profitable trades

### 7. **TimeFilterManager.mqh**
Manages trading time restrictions.
- Trading hours limitations (e.g., 8:00-18:00)
- Weekend trading control
- Day-of-week filters
- Invertible filter logic

### 8. **PositionManager.mqh**
Advanced position management features.
- Partial position closes at profit targets
- Multiple take profit levels with volume distribution
- Automated profit-taking strategies

### 9. **NewsFilterManager.mqh**
Manages news event filtering to avoid trading during high-impact releases.
- Pre-configured major economic events (NFP, CPI, FOMC, etc.)
- Customizable avoidance periods before/after events
- Automatic event scheduling based on typical release times

### 10. **GoldOptimizer.mqh**
Dynamic parameter optimization for gold trading in 2025 market conditions.
- Real-time volatility analysis using ATR
- Market condition detection (low/normal/high/extreme volatility)
- Automatic parameter adjustment based on market state
- RSI sensitivity optimization for trending vs ranging markets

### 11. **DisplayManager.mqh**
Comprehensive chart overlay with real-time EA information.
- Visual dashboard showing EA status, positions, signals, and account info
- Real-time parameter display and optimization status
- Market condition indicators and trading signals
- Customizable colors, fonts, and positioning
- Professional monitoring interface for live trading

### 5. **TrailingStopManager.mqh**
Manages dynamic trailing stop functionality.
- Fixed, percentage-based, or ATR-based trailing modes
- Automatic stop loss adjustment as price moves favorably
- Configurable trailing distance and step size

### 6. **BreakevenManager.mqh**
Handles automatic breakeven moves.
- Moves stop loss to breakeven once profit target is reached
- Optional offset from entry price
- Prevents losses on profitable trades

### 7. **TimeFilterManager.mqh**
Manages trading time restrictions.
- Trading hours limitations (e.g., 8:00-18:00)
- Weekend trading control
- Day-of-week filters
- Invertible filter logic

### 8. **PositionManager.mqh**
Advanced position management features.
- Partial position closes at profit targets
- Multiple take profit levels with volume distribution
- Automated profit taking strategies

## Key Features

- **Indicators**: Uses RSI to identify overbought and oversold conditions and EMA for trend filtering
- **Entry Signals**:
  - Buy when RSI falls below the oversold level and price is above EMA
  - Sell when RSI rises above the overbought level and price is below EMA
- **Risk Management**: Includes configurable Stop Loss and Take Profit levels
- **Position Sizing**: Fixed lot or risk-based (percentage of account)
- **Trend Filter**: Optional EMA filter to trade only in the direction of the trend
- **Trailing Stop**: Dynamic stop loss that follows profitable price movements
- **Breakeven**: Automatic stop loss move to breakeven on profitable trades
- **Time Filters**: Trading time restrictions and weekend control
- **Advanced Position Management**: Partial closes and multiple take profit levels
- **Magic Number**: Unique identifier for orders to avoid conflicts with other EAs
- **Modular Design**: Easy to customize and extend with 8 specialized modules

## Parameters

### Trade Settings
- `LotSize`: The volume of the position (default: 0.01)
- `UseFixedLot`: Use fixed lot size or risk-based sizing (default: true)
- `RiskPercent`: Risk percentage per trade when using risk-based sizing (default: 1.0%)

### Stop Loss & Take Profit
- `StopLoss`: Stop Loss in points (default: 50)
- `TakeProfit`: Take Profit in points (default: 100)

### RSI Settings
- `RSIPeriod`: Period for RSI calculation (default: 14)
- `RSIOverbought`: RSI level for overbought signal (default: 70)
- `RSIOversold`: RSI level for oversold signal (default: 30)

### EMA Trend Filter
- `UseTrendFilter`: Enable/disable EMA trend filter (default: true)
- `EMAPeriod`: Period for EMA calculation (default: 50)

### Expert Advisor Settings
- `MagicNumber`: Magic number for orders (default: 12345)
- `Slippage`: Slippage in points (default: 15, increased for gold volatility)

### Trailing Stop Settings
- `UseTrailingStop`: Enable/disable trailing stop (default: true)
- `TrailingMode`: Trailing mode - Fixed, Percentage, or ATR-based (default: ATR)
- `TrailingDistance`: Trailing distance in points or ATR multiplier (default: 1.5)
- `TrailingStep`: Minimum step to move SL in points (default: 10, increased for gold)
- `ATRPeriod`: ATR period for ATR-based trailing (default: 21)

### Breakeven Settings
- `UseBreakeven`: Enable automatic breakeven (default: true)
- `BreakevenTrigger`: Profit points to trigger breakeven (default: 50.0)
- `BreakevenOffset`: Offset from entry price in points (default: 5.0)
- `PartialBreakeven`: Move SL to breakeven + offset (default: true)

### Time Filter Settings
- `UseTimeFilter`: Enable time-based trading restrictions (default: true)
- `TradingStartHour`: Start trading hour (0-23) (default: 2, early for gold session)
- `TradingEndHour`: End trading hour (0-23) (default: 20, extended for gold)
- `AllowWeekendTrading`: Allow trading on weekends (default: false)
- `InvertTimeFilter`: Invert time filter logic (default: false)

### Advanced Position Management
- `UsePositionManager`: Enable advanced position management (default: true)
- `UsePartialClose`: Enable partial position closes (default: true)
- `PartialCloseTrigger`: Profit points to trigger partial close (default: 100.0)
- `PartialClosePercent`: Percentage of position to close (default: 0.4)
- `UseMultipleTP`: Enable multiple take profit levels (default: true)
- `TP1_Profit`: TP1 profit points (default: 90.0, aligned with gold levels)
- `TP1_Volume`: TP1 volume percentage (default: 0.3)
- `TP1_Enabled`: Enable TP1 (default: true)
- `TP2_Profit`: TP2 profit points (default: 180.0, aligned with gold levels)
- `TP2_Volume`: TP2 volume percentage (default: 0.4)
- `TP2_Enabled`: Enable TP2 (default: true)
- `TP3_Profit`: TP3 profit points (default: 270.0, aligned with gold levels)
- `TP3_Volume`: TP3 volume percentage (default: 0.3)
- `TP3_Enabled`: Enable TP3 (default: false)

### News Filter Settings
- `UseNewsFilter`: Enable news event filtering (default: true)
- `NewsAvoidanceMinutes`: Minutes to avoid before/after news (default: 30)

### Gold Optimization Settings
- `UseGoldOptimizer`: Enable dynamic parameter optimization (default: true)

### Display Settings
- `UseDisplay`: Enable chart overlay display (default: true)
- `DisplayTextColor`: Display text color (default: White)
- `DisplayFontSize`: Display font size (default: 8)
- `DisplayFontName`: Display font name (default: Arial)

### Trailing Stop Settings
- `UseTrailingStop`: Enable/disable trailing stop (default: true)
- `TrailingMode`: Trailing mode - Fixed, Percentage, or ATR-based (default: Fixed)
- `TrailingDistance`: Trailing distance in points or percentage (default: 20.0)
- `TrailingStep`: Minimum step to move SL in points (default: 5.0)
- `ATRPeriod`: ATR period for ATR-based trailing (default: 14)
- `ATRMultiplier`: ATR multiplier for ATR-based trailing (default: 1.5)

### Breakeven Settings
- `UseBreakeven`: Enable automatic breakeven (default: true)
- `BreakevenTrigger`: Profit points to trigger breakeven (default: 20.0)
- `BreakevenOffset`: Offset from entry price in points (default: 2.0)
- `PartialBreakeven`: Move SL to breakeven + offset (default: false)

### Time Filter Settings
- `UseTimeFilter`: Enable time-based trading restrictions (default: true)
- `TradingStartHour`: Start trading hour (0-23) (default: 8)
- `TradingEndHour`: End trading hour (0-23) (default: 18)
- `AllowWeekendTrading`: Allow trading on weekends (default: false)
- `InvertTimeFilter`: Invert time filter logic (default: false)

### Advanced Position Management
- `UsePositionManager`: Enable advanced position management (default: true)
- `UsePartialClose`: Enable partial position closes (default: false)
- `PartialCloseTrigger`: Profit points to trigger partial close (default: 50.0)
- `PartialClosePercent`: Percentage of position to close (default: 0.5)
- `UseMultipleTP`: Enable multiple take profit levels (default: false)
- `TP1_Profit`: TP1 profit points (default: 25.0)
- `TP1_Volume`: TP1 volume percentage (default: 0.33)
- `TP1_Enabled`: Enable TP1 (default: false)
- `TP2_Profit`: TP2 profit points (default: 50.0)
- `TP2_Volume`: TP2 volume percentage (default: 0.33)
- `TP2_Enabled`: Enable TP2 (default: false)
- `TP3_Profit`: TP3 profit points (default: 75.0)
- `TP3_Volume`: TP3 volume percentage (default: 0.34)
- `TP3_Enabled`: Enable TP3 (default: false)

## File Structure

```
EA-AK47Hybrid/
├── EA-AK47Hybrid.mq5          # Main EA file
├── Include/                   # Module directory
│   ├── IndicatorManager.mqh   # Indicator management module
│   ├── TradeManager.mqh       # Trade execution module
│   ├── SignalManager.mqh      # Signal generation module
│   ├── RiskManager.mqh        # Risk management module
│   ├── TrailingStopManager.mqh # Trailing stop management module
│   ├── BreakevenManager.mqh   # Breakeven management module
│   ├── TimeFilterManager.mqh  # Time filter management module
│   └── PositionManager.mqh    # Advanced position management module
├── EA-AK47Hybrid.ex5          # Compiled executable
├── compile.log                # Compilation log
└── README.md                  # This file
```

## Usage

### Installation
1. Copy the entire `EA-AK47Hybrid` folder to your MetaTrader 5 `MQL5\Experts` directory
2. Compile the EA in MetaEditor (F7)
3. Restart MetaTrader 5 or refresh the Navigator panel

### Running the EA
1. Attach the EA to a **Gold (XAU/USD)** chart (optimized for 2025 conditions)
2. Recommended timeframe: **H1** or **H4** for gold trading
3. Adjust parameters in the input settings as needed
4. Enable automated trading (AutoTrading button in MT5)
5. Monitor the Expert tab in the Terminal window for logs

### 2025 Gold Trading Optimization
- **ATR Trailing**: Automatically adapts to gold's volatility
- **News Avoidance**: Skips trading during major economic events
- **Multiple TP Levels**: Takes profit at key gold resistance levels
- **Time Filters**: Trades during optimal gold session hours
- **Dynamic Optimization**: Adjusts parameters based on market conditions

### Recommended Settings for 2025 Gold Trading
- **Symbol**: XAU/USD (Gold)
- **Timeframe**: H1 or H4 (higher timeframes for gold's volatility)
- **Stop Loss**: 120 points (increased for gold volatility)
- **Take Profit**: 250 points (increased for gold volatility)
- **RSI Period**: 21 (longer period for smoother signals)
- **RSI Levels**: Oversold 25, Overbought 75 (adjusted for gold trends)
- **EMA Period**: 100 (longer for gold trend filtering)
- **Trailing Stop**: ATR-based with 1.5 multiplier
- **Multiple TP**: Enabled with levels at 90, 180, 270 points
- **News Filter**: Enabled (30-minute avoidance)
- **Time Filter**: 2:00-20:00 UTC (optimal gold trading hours)
- **Gold Optimizer**: Enabled (dynamic parameter adjustment)

## Strategy Logic

1. **Time Filtering**: Check if trading is allowed at current time (optional)
2. **Indicator Calculation**: The EA calculates RSI and EMA values on each tick
3. **Signal Generation**:
   - **Buy Signal**: RSI < Oversold level AND price > EMA (when trend filter enabled)
   - **Sell Signal**: RSI > Overbought level AND price < EMA (when trend filter enabled)
4. **Position Management**: Opens one position at a time in each direction
5. **Advanced Position Management** (optional):
   - Process partial closes at profit targets
   - Execute multiple take profit levels
6. **Trailing Stop**: Adjust stop losses dynamically as price moves favorably
7. **Breakeven**: Move stop loss to breakeven on profitable trades
8. **Exit Strategy**: Positions are closed either by:
   - Stop Loss or Take Profit hit
   - Opposite signal (optional scalping mode)
   - Partial closes or multiple TP levels
   - Trailing stop or breakeven adjustments

## Customization

The modular design makes it easy to customize:

### Adding New Indicators
Edit `IndicatorManager.mqh` to add new indicator handles and calculation methods.

### Changing Entry/Exit Logic
Modify `SignalManager.mqh` to implement different signal generation rules.

### Custom Risk Management
Update `RiskManager.mqh` to implement advanced position sizing algorithms (e.g., Kelly Criterion, Fixed Ratio).

### Additional Trade Filters
Add new modules in the `Include` folder and integrate them in the main `EA-AK47Hybrid.mq5` file.

## Testing

Always test the EA thoroughly before live trading:

1. **Strategy Tester**: Use MT5's built-in strategy tester with historical data
2. **Demo Account**: Run on a demo account for at least 1-2 weeks
3. **Small Live Account**: Start with minimal lot sizes on a live account
4. **Monitor Performance**: Track win rate, profit factor, and drawdown

## Disclaimer

This EA is for educational and testing purposes only. Trading involves substantial risk, and past performance does not guarantee future results. Use at your own risk and test thoroughly in a demo account before live trading.

**Important Notes:**
- Never risk more than you can afford to lose
- Use proper risk management (1-2% per trade maximum)
- Monitor your trades regularly
- Adjust parameters based on market conditions
- Past performance is not indicative of future results

## Requirements

- MetaTrader 5 platform
- Minimum account balance: $100 (for proper risk management)
- Compatible with any symbol and timeframe
- Optimized for Forex pairs, but can work with other instruments

## Support

For issues, questions, or suggestions:
- Review the Expert logs in the MT5 Terminal
- Check that all module files are in the correct location
- Ensure indicators are properly initialized
- Verify account permissions for automated trading

## Version History

- **v1.10** - Advanced features release
  - Added TrailingStopManager for dynamic stop loss management
  - Added BreakevenManager for automatic breakeven moves
  - Added TimeFilterManager for trading time restrictions
  - Added PositionManager for partial closes and multiple take profits
  - Enhanced modular architecture with 8 specialized modules
  - Comprehensive input parameters for all new features
  - Improved position management and risk control
## Version History

- **v1.10** - Advanced 2025 Gold Trading Features Release
  - Added TrailingStopManager for dynamic stop loss management
  - Added BreakevenManager for automatic breakeven moves
  - Added TimeFilterManager for trading time restrictions
  - Added PositionManager for partial closes and multiple take profits
  - Added NewsFilterManager to avoid trading during high-impact events
  - Added GoldOptimizer for dynamic parameter adjustment based on market conditions
  - Added DisplayManager for comprehensive chart overlay with real-time information
  - Optimized parameters for gold (XAU/USD) trading in 2025
  - Increased stop loss/take profit for higher volatility
  - ATR-based trailing stops for volatility adaptation
  - Multiple take profit levels aligned with gold technical levels
  - News filtering for major economic events (ADP, NFP, FOMC, etc.)
  - Professional chart overlay for monitoring and control
  - Enhanced modular architecture with 11 specialized modules
  - Comprehensive input parameters for all new features

- **v1.00** - Initial release with modular architecture
  - RSI + EMA strategy
  - Modular design with 4 separate components
  - Risk management with fixed and percentage-based sizing
  - Comprehensive logging and error handling

## License

Copyright (c) 2025 zombitx64

All rights reserved.

This software (EA-AK47Hybrid Expert Advisor) is the intellectual property of zombitx64.

**PERMISSION IS HEREBY DENIED to:**
- Modify, adapt, alter, or create derivative works of this software
- Sell, distribute, sublicense, or commercially exploit this software in any form
- Use this software for any commercial purposes without explicit written permission from zombitx64

This software is provided "AS IS" for personal, non-commercial use only. The author (zombitx64) assumes no responsibility for any damages or losses resulting from the use of this software.

For inquiries or permissions, please contact the author.

By using this software, you agree to these terms.

See the [LICENSE](LICENSE) file for full license details.

---

**Happy Trading! Remember: Trade smart, manage your risk, and always test before going live.**