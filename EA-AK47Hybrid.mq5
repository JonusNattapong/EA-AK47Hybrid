//+------------------------------------------------------------------+
//|                                                EA-AK47Hybrid.mq5 |
//|                        Copyright 2023, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property description "EA Scalper Long-Term - Modular Architecture"
#property description "Uses RSI and EMA for trend-following scalping strategy"

//--- Include modules
#include "Include\IndicatorManager.mqh"
#include "Include\TradeManager.mqh"
#include "Include\SignalManager.mqh"
#include "Include\RiskManager.mqh"
#include "Include\TrailingStopManager.mqh"
#include "Include\BreakevenManager.mqh"
#include "Include\TimeFilterManager.mqh"
#include "Include\PositionManager.mqh"
#include "Include\NewsFilterManager.mqh"
#include "Include\GoldOptimizer.mqh"
#include "Include\DisplayManager.mqh"

//--- Input parameters
input group "=== Trade Settings ==="
input double   LotSize = 0.01;           // Lot size
input bool     UseFixedLot = true;       // Use fixed lot size
input double   RiskPercent = 1.0;        // Risk percentage per trade

input group "=== Stop Loss & Take Profit ==="
input int      StopLoss = 120;           // Stop Loss in points (increased for gold volatility)
input int      TakeProfit = 250;         // Take Profit in points (increased for gold volatility)

input group "=== RSI Settings ==="
input int      RSIPeriod = 21;           // RSI period (increased for smoother signals in gold)
input int      RSIOverbought = 75;       // RSI overbought level (adjusted for gold trends)
input int      RSIOversold = 25;         // RSI oversold level (adjusted for gold trends)

input group "=== EMA Trend Filter ==="
input bool     UseTrendFilter = true;    // Use EMA trend filter
input int      EMAPeriod = 100;          // EMA period for trend filter (longer for gold trends)

input group "=== Expert Advisor Settings ==="
input int      MagicNumber = 12345;      // Magic number for orders
input int      Slippage = 15;            // Slippage in points (increased for gold volatility)

input group "=== Trailing Stop Settings ==="
input bool     UseTrailingStop = true;   // Enable trailing stop
input ENUM_TRAILING_MODE TrailingMode = TRAILING_MODE_ATR; // Trailing mode (ATR for volatility adaptation)
input double   TrailingDistance = 1.5;   // Trailing distance (ATR multiplier)
input double   TrailingStep = 10.0;      // Minimum step to move SL (points, increased for gold)
input int      ATRPeriod = 21;           // ATR period for ATR mode (longer for gold trends)
input double   ATRMultiplier = 1.5;      // ATR multiplier for ATR mode

input group "=== Breakeven Settings ==="
input bool     UseBreakeven = true;      // Enable automatic breakeven
input double   BreakevenTrigger = 50.0;  // Profit points to trigger breakeven (higher for gold)
input double   BreakevenOffset = 5.0;    // Offset from entry price (points, increased for gold)
input bool     PartialBreakeven = true;  // Move SL to breakeven + offset (enabled for gold)

input group "=== Time Filter Settings ==="
input bool     UseTimeFilter = true;     // Enable time-based trading restrictions
input int      TradingStartHour = 2;     // Start trading hour (0-23, early for gold session)
input int      TradingEndHour = 20;      // End trading hour (0-23, extended for gold)
input bool     AllowWeekendTrading = false; // Allow trading on weekends
input bool     InvertTimeFilter = false; // Invert time filter logic

input group "=== Advanced Position Management ==="
input bool     UsePositionManager = true; // Enable advanced position management
input bool     UsePartialClose = true;    // Enable partial position closes (enabled for gold)
input double   PartialCloseTrigger = 100.0; // Profit points to trigger partial close (higher for gold)
input double   PartialClosePercent = 0.4; // Percentage of position to close (40% for gold)
input bool     UseMultipleTP = true;      // Enable multiple take profit levels (enabled for gold)
input double   TP1_Profit = 90.0;         // TP1 profit points (aligned with gold levels)
input double   TP1_Volume = 0.3;          // TP1 volume percentage
input bool     TP1_Enabled = true;        // Enable TP1
input double   TP2_Profit = 180.0;        // TP2 profit points (aligned with gold levels)
input double   TP2_Volume = 0.4;          // TP2 volume percentage
input bool     TP2_Enabled = true;        // Enable TP2
input double   TP3_Profit = 270.0;        // TP3 profit points (aligned with gold levels)
input double   TP3_Volume = 0.3;          // TP3 volume percentage
input bool     TP3_Enabled = false;       // Enable TP3

input group "=== News Filter Settings ==="
input bool     UseNewsFilter = true;      // Enable news event filtering
input int      NewsAvoidanceMinutes = 30; // Minutes to avoid before/after news

input group "=== Display Settings ==="
input bool     UseDisplay = true;         // Enable chart overlay display
input color    DisplayTextColor = clrWhite; // Display text color
input int      DisplayFontSize = 8;       // Display font size
input string   DisplayFontName = "Arial"; // Display font name

//--- Global objects
CIndicatorManager     *g_indicator_manager;
CTradeManager         *g_trade_manager;
CSignalManager        *g_signal_manager;
CRiskManager          *g_risk_manager;
CTrailingStopManager  *g_trailing_manager;
CBreakevenManager     *g_breakeven_manager;
CTimeFilterManager    *g_time_filter_manager;
CPositionManager      *g_position_manager;
CNewsFilterManager    *g_news_filter_manager;
CGoldOptimizer        *g_gold_optimizer;
CDisplayManager       *g_display_manager;

//--- Global variables
datetime           g_last_bar_time = 0;
bool               g_initialized = false;



//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   Print("=== EA-AK47Hybrid Initialization Started ===");

//--- Create indicator manager
   g_indicator_manager = new CIndicatorManager();
   if(g_indicator_manager == NULL)
     {
      Print("Error: Failed to create Indicator Manager");
      return(INIT_FAILED);
     }

//--- Initialize indicator manager
   if(!g_indicator_manager.Init(_Symbol, _Period, RSIPeriod, EMAPeriod))
     {
      Print("Error: Failed to initialize Indicator Manager");
      delete g_indicator_manager;
      return(INIT_FAILED);
     }

//--- Create trade manager
   g_trade_manager = new CTradeManager();
   if(g_trade_manager == NULL)
     {
      Print("Error: Failed to create Trade Manager");
      delete g_indicator_manager;
      return(INIT_FAILED);
     }

//--- Initialize trade manager
   g_trade_manager.Init(_Symbol, MagicNumber, LotSize, StopLoss, TakeProfit, Slippage);

//--- Create signal manager
   g_signal_manager = new CSignalManager();
   if(g_signal_manager == NULL)
     {
      Print("Error: Failed to create Signal Manager");
      delete g_indicator_manager;
      delete g_trade_manager;
      return(INIT_FAILED);
     }

//--- Initialize signal manager
   g_signal_manager.Init(g_indicator_manager, RSIOversold, RSIOverbought, UseTrendFilter, _Symbol);

//--- Create risk manager
   g_risk_manager = new CRiskManager();
   if(g_risk_manager == NULL)
     {
      Print("Error: Failed to create Risk Manager");
      delete g_indicator_manager;
      delete g_trade_manager;
      delete g_signal_manager;
      return(INIT_FAILED);
     }

//--- Initialize risk manager
   g_risk_manager.Init(_Symbol, RiskPercent, LotSize, UseFixedLot);

//--- Create trailing stop manager
   g_trailing_manager = new CTrailingStopManager();
   if(g_trailing_manager == NULL)
     {
      Print("Error: Failed to create Trailing Stop Manager");
      delete g_indicator_manager;
      delete g_trade_manager;
      delete g_signal_manager;
      delete g_risk_manager;
      return(INIT_FAILED);
     }

//--- Initialize trailing stop manager
   g_trailing_manager.Init(_Symbol, MagicNumber, UseTrailingStop, TrailingMode,
                          TrailingDistance, TrailingStep, ATRPeriod, ATRMultiplier);

//--- Create breakeven manager
   g_breakeven_manager = new CBreakevenManager();
   if(g_breakeven_manager == NULL)
     {
      Print("Error: Failed to create Breakeven Manager");
      delete g_indicator_manager;
      delete g_trade_manager;
      delete g_signal_manager;
      delete g_risk_manager;
      delete g_trailing_manager;
      return(INIT_FAILED);
     }

//--- Initialize breakeven manager
   g_breakeven_manager.Init(_Symbol, MagicNumber, UseBreakeven, BreakevenTrigger,
                           BreakevenOffset, PartialBreakeven);

//--- Create time filter manager
   g_time_filter_manager = new CTimeFilterManager();
   if(g_time_filter_manager == NULL)
     {
      Print("Error: Failed to create Time Filter Manager");
      delete g_indicator_manager;
      delete g_trade_manager;
      delete g_signal_manager;
      delete g_risk_manager;
      delete g_trailing_manager;
      delete g_breakeven_manager;
      return(INIT_FAILED);
     }

//--- Initialize time filter manager
   g_time_filter_manager.Init(_Symbol, UseTimeFilter, true, TradingStartHour,
                             TradingEndHour, AllowWeekendTrading, InvertTimeFilter);

//--- Create position manager
   g_position_manager = new CPositionManager();
   if(g_position_manager == NULL)
     {
      Print("Error: Failed to create Position Manager");
      delete g_indicator_manager;
      delete g_trade_manager;
      delete g_signal_manager;
      delete g_risk_manager;
      delete g_trailing_manager;
      delete g_breakeven_manager;
      delete g_time_filter_manager;
      return(INIT_FAILED);
     }

//--- Initialize position manager
   g_position_manager.Init(_Symbol, MagicNumber, UsePositionManager);

//--- Configure position manager
   if(UsePartialClose)
      g_position_manager.SetPartialClose(true, PartialCloseTrigger, PartialClosePercent);

   if(UseMultipleTP)
     {
      g_position_manager.SetMultipleTPEnabled(true);
      g_position_manager.SetTakeProfitLevel(0, TP1_Profit, TP1_Volume, TP1_Enabled);
      g_position_manager.SetTakeProfitLevel(1, TP2_Profit, TP2_Volume, TP2_Enabled);
      g_position_manager.SetTakeProfitLevel(2, TP3_Profit, TP3_Volume, TP3_Enabled);
        }

   //--- Create news filter manager
      g_news_filter_manager = new CNewsFilterManager();
      if(g_news_filter_manager == NULL)
        {
         Print("Error: Failed to create News Filter Manager");
         delete g_indicator_manager;
         delete g_trade_manager;
         delete g_signal_manager;
         delete g_risk_manager;
         delete g_trailing_manager;
         delete g_breakeven_manager;
         delete g_time_filter_manager;
         delete g_position_manager;
         return(INIT_FAILED);
        }

   //--- Initialize news filter manager
      g_news_filter_manager.Init(_Symbol, UseNewsFilter);

   //--- Create gold optimizer
      g_gold_optimizer = new CGoldOptimizer();
      if(g_gold_optimizer == NULL)
        {
         Print("Error: Failed to create Gold Optimizer");
         delete g_indicator_manager;
         delete g_trade_manager;
         delete g_signal_manager;
         delete g_risk_manager;
         delete g_trailing_manager;
         delete g_breakeven_manager;
         delete g_time_filter_manager;
         delete g_position_manager;
         delete g_news_filter_manager;
         return(INIT_FAILED);
        }

   //--- Initialize gold optimizer
      g_gold_optimizer.Init(_Symbol, true, StopLoss, TakeProfit, RSIPeriod, RSIOverbought, RSIOversold);

   //--- Create display manager
      g_display_manager = new CDisplayManager();
      if(g_display_manager == NULL)
        {
         Print("Error: Failed to create Display Manager");
         delete g_indicator_manager;
         delete g_trade_manager;
         delete g_signal_manager;
         delete g_risk_manager;
         delete g_trailing_manager;
         delete g_breakeven_manager;
         delete g_time_filter_manager;
         delete g_position_manager;
         delete g_news_filter_manager;
         delete g_gold_optimizer;
         return(INIT_FAILED);
        }

   //--- Initialize display manager
      g_display_manager.Init(_Symbol, UseDisplay, DisplayTextColor, DisplayFontSize, DisplayFontName, g_signal_manager, g_gold_optimizer);

   //--- Check minimum bars
   if(Bars(_Symbol, _Period) < 100)
     {
      Print("Warning: Not enough bars on chart. Minimum 100 bars required.");
     }

//--- Initialization successful
   g_initialized = true;
   g_last_bar_time = iTime(_Symbol, _Period, 0);

   Print("=== EA-AK47Hybrid Initialized Successfully ===");
   Print("Symbol: ", _Symbol);
   Print("Timeframe: ", EnumToString(_Period));
   Print("RSI Period: ", RSIPeriod, " | Oversold: ", RSIOversold, " | Overbought: ", RSIOverbought);
   Print("EMA Period: ", EMAPeriod, " | Trend Filter: ", (UseTrendFilter ? "Enabled" : "Disabled"));
   Print("Stop Loss: ", StopLoss, " | Take Profit: ", TakeProfit);
   Print("Lot Size: ", LotSize, " | Use Fixed Lot: ", (UseFixedLot ? "Yes" : "No"));
   Print("Magic Number: ", MagicNumber);
   Print("Trailing Stop: ", (UseTrailingStop ? "Enabled" : "Disabled"));
   Print("Breakeven: ", (UseBreakeven ? "Enabled" : "Disabled"));
   Print("Time Filter: ", (UseTimeFilter ? "Enabled" : "Disabled"));
   Print("Position Manager: ", (UsePositionManager ? "Enabled" : "Disabled"));
   Print("News Filter: ", (UseNewsFilter ? "Enabled" : "Disabled"));
   Print("Gold Optimizer: Enabled (Dynamic parameter adjustment for 2025 market conditions)");
   Print("Display Overlay: ", (UseDisplay ? "Enabled" : "Disabled"));

   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   Print("=== EA-AK47Hybrid Deinitialization ===");
   Print("Reason: ", getUninitReasonText(reason));

//--- Delete all objects
   if(g_indicator_manager != NULL)
     {
      delete g_indicator_manager;
      g_indicator_manager = NULL;
     }

   if(g_trade_manager != NULL)
     {
      delete g_trade_manager;
      g_trade_manager = NULL;
     }

   if(g_signal_manager != NULL)
     {
      delete g_signal_manager;
      g_signal_manager = NULL;
     }

   if(g_risk_manager != NULL)
     {
      delete g_risk_manager;
      g_risk_manager = NULL;
     }

   if(g_trailing_manager != NULL)
     {
      delete g_trailing_manager;
      g_trailing_manager = NULL;
     }

   if(g_breakeven_manager != NULL)
     {
      delete g_breakeven_manager;
      g_breakeven_manager = NULL;
     }

   if(g_time_filter_manager != NULL)
     {
      delete g_time_filter_manager;
      g_time_filter_manager = NULL;
     }

   if(g_position_manager != NULL)
     {
      delete g_position_manager;
      g_position_manager = NULL;
     }

   if(g_news_filter_manager != NULL)
     {
      delete g_news_filter_manager;
      g_news_filter_manager = NULL;
     }

   if(g_gold_optimizer != NULL)
     {
      delete g_gold_optimizer;
      g_gold_optimizer = NULL;
     }

   if(g_display_manager != NULL)
     {
      delete g_display_manager;
      g_display_manager = NULL;
     }

   Print("=== EA-AK47Hybrid Deinitialized ===");
  }

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//--- Check if initialized
   if(!g_initialized)
      return;

//--- Check if we have enough bars
   if(Bars(_Symbol, _Period) < 100)
      return;

//--- Check time filter first
   if(g_time_filter_manager.IsEnabled() && !g_time_filter_manager.CanTrade())
     {
      // Print("Trading not allowed at current time"); // Uncomment for debugging
      return;
     }

//--- Check news filter
   if(g_news_filter_manager.IsEnabled() && !g_news_filter_manager.CanTrade())
     {
      // Print("Trading not allowed during news events"); // Uncomment for debugging
      return;
     }

//--- Check for new bar (optional - for bar-based trading)
   datetime current_bar_time = iTime(_Symbol, _Period, 0);
   bool is_new_bar = (current_bar_time != g_last_bar_time);

   if(is_new_bar)
     {
      g_last_bar_time = current_bar_time;
     }

//--- Update gold optimizer (dynamic parameter adjustment)
   if(g_gold_optimizer.IsEnabled())
      g_gold_optimizer.UpdateOptimization();

//--- Update display overlay
   if(g_display_manager.IsEnabled())
      g_display_manager.UpdateDisplay();

//--- Update indicators
   if(!g_indicator_manager.Update())
     {
      // Print("Error updating indicators"); // Uncomment for debugging
      return;
     }

//--- Get current signal
   ENUM_SIGNAL_TYPE signal = g_signal_manager.GetSignal();

//--- Process advanced position management
   if(g_position_manager.IsEnabled())
      g_position_manager.ProcessPositions();

//--- Process trailing stops
   if(g_trailing_manager.IsEnabled())
      g_trailing_manager.ProcessTrailingStops();

//--- Process breakeven
   if(g_breakeven_manager.IsEnabled())
      g_breakeven_manager.ProcessBreakeven();

//--- Check existing positions
   bool has_buy = g_trade_manager.HasBuyPosition();
   bool has_sell = g_trade_manager.HasSellPosition();

//--- Execute trading logic
   if(signal == SIGNAL_BUY && !has_buy)
     {
      // Check if we should close sell position first (for scalping)
      if(has_sell)
        {
         Print("Opposite signal detected - Closing sell positions");
         g_trade_manager.CloseAllPositions();
         Sleep(100); // Small delay after closing
        }

      // Open buy position
      double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);

      // Check margin before opening
      if(g_risk_manager.CheckMargin(LotSize, ORDER_TYPE_BUY))
        {
         Print("BUY Signal detected - RSI: ", DoubleToString(g_indicator_manager.GetRSI(), 2),
               " | EMA: ", DoubleToString(g_indicator_manager.GetEMA(), _Digits));

         if(g_trade_manager.OpenBuy(ask))
           {
            Print("Buy position opened successfully");
           }
        }
      else
        {
         Print("Not enough margin to open buy position");
        }
     }
   else if(signal == SIGNAL_SELL && !has_sell)
     {
      // Check if we should close buy position first (for scalping)
      if(has_buy)
        {
         Print("Opposite signal detected - Closing buy positions");
         g_trade_manager.CloseAllPositions();
         Sleep(100); // Small delay after closing
        }

      // Open sell position
      double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);

      // Check margin before opening
      if(g_risk_manager.CheckMargin(LotSize, ORDER_TYPE_SELL))
        {
         Print("SELL Signal detected - RSI: ", DoubleToString(g_indicator_manager.GetRSI(), 2),
               " | EMA: ", DoubleToString(g_indicator_manager.GetEMA(), _Digits));

         if(g_trade_manager.OpenSell(bid))
           {
            Print("Sell position opened successfully");
           }
        }
      else
        {
         Print("Not enough margin to open sell position");
        }
     }
  }

//+------------------------------------------------------------------+
//| Get uninit reason text                                           |
//+------------------------------------------------------------------+
string getUninitReasonText(int reason)
  {
   string text = "";

   switch(reason)
     {
      case REASON_PROGRAM:
         text = "Expert Advisor terminated its operation by calling the ExpertRemove() function";
         break;
      case REASON_REMOVE:
         text = "Program removed from the chart";
         break;
      case REASON_RECOMPILE:
         text = "Program recompiled";
         break;
      case REASON_CHARTCHANGE:
         text = "Symbol or chart period changed";
         break;
      case REASON_CHARTCLOSE:
         text = "Chart closed";
         break;
      case REASON_PARAMETERS:
         text = "Input parameters changed";
         break;
      case REASON_ACCOUNT:
         text = "Account changed";
         break;
      case REASON_TEMPLATE:
         text = "New template applied";
         break;
      case REASON_INITFAILED:
         text = "Initialization failed";
         break;
      case REASON_CLOSE:
         text = "Terminal closed";
         break;
      default:
         text = "Unknown reason";
         break;
     }

   return text;
  }
//+------------------------------------------------------------------+
