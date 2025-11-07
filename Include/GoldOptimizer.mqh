//+------------------------------------------------------------------+
//|                                           GoldOptimizer.mqh |
//|                        Copyright 2025, zombitx64 |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, zombitx64"
#property link      "https://www.mql5.com"
#property version   "1.00"

//--- Include necessary libraries
#include <Trade\PositionInfo.mqh>

//--- Enums
enum ENUM_MARKET_CONDITION
  {
   MARKET_CONDITION_LOW_VOLATILITY,    // Low volatility environment
   MARKET_CONDITION_NORMAL_VOLATILITY, // Normal volatility
   MARKET_CONDITION_HIGH_VOLATILITY,   // High volatility environment
   MARKET_CONDITION_EXTREME_VOLATILITY // Extreme volatility (news events, etc.)
  };

//+------------------------------------------------------------------+
//| Class CGoldOptimizer                                              |
//| Purpose: Dynamically optimizes EA parameters based on gold market |
//|          conditions for 2025 trading environment                 |
//+------------------------------------------------------------------+
class CGoldOptimizer
  {
private:
   string             m_symbol;
   bool               m_enabled;
   ENUM_MARKET_CONDITION m_current_condition;

   //--- Base parameters (from inputs)
   double             m_base_stop_loss;
   double             m_base_take_profit;
   int                m_base_rsi_period;
   int                m_base_rsi_overbought;
   int                m_base_rsi_oversold;

   //--- Optimized parameters (calculated)
   double             m_opt_stop_loss;
   double             m_opt_take_profit;
   int                m_opt_rsi_period;
   int                m_opt_rsi_overbought;
   int                m_opt_rsi_oversold;

   //--- Market analysis
   double             m_current_atr;
   double             m_average_atr;
   double             m_dollar_correlation;
   bool               m_is_trending;

   //--- Internal methods
   ENUM_MARKET_CONDITION AnalyzeMarketCondition();
   double             CalculateATR();
   double             CalculateAverageATR(int periods = 20);
   double             CalculateDollarCorrelation();
   bool               IsTrending();
   void               OptimizeParameters();

public:
   //--- Constructor/Destructor
                     CGoldOptimizer();
                    ~CGoldOptimizer();

   //--- Initialization
   bool               Init(string symbol, bool enabled = true,
                          double base_sl = 120.0, double base_tp = 250.0,
                          int base_rsi_period = 21, int base_rsi_ob = 75, int base_rsi_os = 25);

   //--- Main methods
   void               UpdateOptimization();
   bool               IsEnabled() { return m_enabled; }

   //--- Get optimized parameters
   double             GetOptimizedStopLoss() { return m_opt_stop_loss; }
   double             GetOptimizedTakeProfit() { return m_opt_take_profit; }
   int                GetOptimizedRSIPeriod() { return m_opt_rsi_period; }
   int                GetOptimizedRSIOverbought() { return m_opt_rsi_overbought; }
   int                GetOptimizedRSIOversold() { return m_opt_rsi_oversold; }
   ENUM_MARKET_CONDITION GetMarketCondition() { return m_current_condition; }

   //--- Setters
   void               SetEnabled(bool enabled) { m_enabled = enabled; }
   void               SetBaseParameters(double sl, double tp, int rsi_period, int rsi_ob, int rsi_os);
  };

//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CGoldOptimizer::CGoldOptimizer()
  {
   m_symbol = "";
   m_enabled = false;
   m_current_condition = MARKET_CONDITION_NORMAL_VOLATILITY;

   m_base_stop_loss = 120.0;
   m_base_take_profit = 250.0;
   m_base_rsi_period = 21;
   m_base_rsi_overbought = 75;
   m_base_rsi_oversold = 25;

   m_opt_stop_loss = m_base_stop_loss;
   m_opt_take_profit = m_base_take_profit;
   m_opt_rsi_period = m_base_rsi_period;
   m_opt_rsi_overbought = m_base_rsi_overbought;
   m_opt_rsi_oversold = m_base_rsi_oversold;

   m_current_atr = 0.0;
   m_average_atr = 0.0;
   m_dollar_correlation = 0.0;
   m_is_trending = false;
  }

//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CGoldOptimizer::~CGoldOptimizer()
  {
  }

//+------------------------------------------------------------------+
//| Initialize the gold optimizer                                    |
//+------------------------------------------------------------------+
bool CGoldOptimizer::Init(string symbol, bool enabled = true,
                         double base_sl = 120.0, double base_tp = 250.0,
                         int base_rsi_period = 21, int base_rsi_ob = 75, int base_rsi_os = 25)
  {
   m_symbol = symbol;
   m_enabled = enabled;

   m_base_stop_loss = base_sl;
   m_base_take_profit = base_tp;
   m_base_rsi_period = base_rsi_period;
   m_base_rsi_overbought = base_rsi_ob;
   m_base_rsi_oversold = base_rsi_os;

   //--- Initialize optimized parameters with base values
   m_opt_stop_loss = m_base_stop_loss;
   m_opt_take_profit = m_base_take_profit;
   m_opt_rsi_period = m_base_rsi_period;
   m_opt_rsi_overbought = m_base_rsi_overbought;
   m_opt_rsi_oversold = m_base_rsi_oversold;

   return true;
  }

//+------------------------------------------------------------------+
//| Update optimization based on current market conditions          |
//+------------------------------------------------------------------+
void CGoldOptimizer::UpdateOptimization()
  {
   if(!m_enabled)
      return;

   //--- Analyze current market condition
   m_current_condition = AnalyzeMarketCondition();

   //--- Calculate market metrics
   m_current_atr = CalculateATR();
   m_average_atr = CalculateAverageATR();
   m_dollar_correlation = CalculateDollarCorrelation();
   m_is_trending = IsTrending();

   //--- Optimize parameters based on analysis
   OptimizeParameters();
  }

//+------------------------------------------------------------------+
//| Analyze current market condition                                 |
//+------------------------------------------------------------------+
ENUM_MARKET_CONDITION CGoldOptimizer::AnalyzeMarketCondition()
  {
   if(m_current_atr == 0.0)
      return MARKET_CONDITION_NORMAL_VOLATILITY;

   double volatility_ratio = m_current_atr / m_average_atr;

   if(volatility_ratio >= 2.0)
      return MARKET_CONDITION_EXTREME_VOLATILITY;
   else if(volatility_ratio >= 1.5)
      return MARKET_CONDITION_HIGH_VOLATILITY;
   else if(volatility_ratio <= 0.7)
      return MARKET_CONDITION_LOW_VOLATILITY;
   else
      return MARKET_CONDITION_NORMAL_VOLATILITY;
  }

//+------------------------------------------------------------------+
//| Calculate current ATR value                                      |
//+------------------------------------------------------------------+
double CGoldOptimizer::CalculateATR()
  {
   double atr_buffer[];
   ArraySetAsSeries(atr_buffer, true);

   int atr_handle = iATR(m_symbol, _Period, 14);
   if(atr_handle == INVALID_HANDLE)
      return 0.0;

   if(CopyBuffer(atr_handle, 0, 0, 1, atr_buffer) <= 0)
     {
      IndicatorRelease(atr_handle);
      return 0.0;
     }

   IndicatorRelease(atr_handle);
   return atr_buffer[0];
  }

//+------------------------------------------------------------------+
//| Calculate average ATR over specified periods                    |
//+------------------------------------------------------------------+
double CGoldOptimizer::CalculateAverageATR(int periods = 20)
  {
   double atr_sum = 0.0;
   int valid_periods = 0;

   for(int i = 1; i <= periods; i++)
     {
      double atr_buffer[];
      ArraySetAsSeries(atr_buffer, true);

      int atr_handle = iATR(m_symbol, _Period, 14);
      if(atr_handle == INVALID_HANDLE)
         continue;

      if(CopyBuffer(atr_handle, 0, i, 1, atr_buffer) > 0)
        {
         atr_sum += atr_buffer[0];
         valid_periods++;
        }

      IndicatorRelease(atr_handle);
     }

   return (valid_periods > 0) ? atr_sum / valid_periods : 0.0;
  }

//+------------------------------------------------------------------+
//| Calculate correlation with USD (using DXY if available)         |
//+------------------------------------------------------------------+
double CGoldOptimizer::CalculateDollarCorrelation()
  {
   //--- For simplicity, we'll use a basic approximation
   //--- In a real implementation, you'd calculate proper correlation
   //--- For now, return a neutral value
   return 0.0;  // Neutral correlation
  }

//+------------------------------------------------------------------+
//| Check if market is in a trending phase                          |
//+------------------------------------------------------------------+
bool CGoldOptimizer::IsTrending()
  {
   //--- Simple trend detection using EMA slope
   double ema_buffer[];

   //--- Get current EMA50 value
   int ema_handle_fast = iMA(m_symbol, _Period, 50, 0, MODE_EMA, PRICE_CLOSE);
   if(ema_handle_fast == INVALID_HANDLE) return false;
   ArraySetAsSeries(ema_buffer, true);
   if(CopyBuffer(ema_handle_fast, 0, 0, 2, ema_buffer) <= 0) {
      IndicatorRelease(ema_handle_fast);
      return false;
   }
   double ema_fast = ema_buffer[0];
   double ema_fast_prev = ema_buffer[1];
   IndicatorRelease(ema_handle_fast);

   //--- Get current EMA100 value
   int ema_handle_slow = iMA(m_symbol, _Period, 100, 0, MODE_EMA, PRICE_CLOSE);
   if(ema_handle_slow == INVALID_HANDLE) return false;
   ArraySetAsSeries(ema_buffer, true);
   if(CopyBuffer(ema_handle_slow, 0, 0, 2, ema_buffer) <= 0) {
      IndicatorRelease(ema_handle_slow);
      return false;
   }
   double ema_slow = ema_buffer[0];
   double ema_slow_prev = ema_buffer[1];
   IndicatorRelease(ema_handle_slow);

   //--- Check if EMAs are moving in the same direction
   bool fast_trending = MathAbs(ema_fast - ema_fast_prev) > _Point * 10;
   bool slow_trending = MathAbs(ema_slow - ema_slow_prev) > _Point * 5;

   return fast_trending && slow_trending;
  }

//+------------------------------------------------------------------+
//| Optimize parameters based on market analysis                     |
//+------------------------------------------------------------------+
void CGoldOptimizer::OptimizeParameters()
  {
   double volatility_multiplier = 1.0;

   //--- Adjust multiplier based on market condition
   switch(m_current_condition)
     {
      case MARKET_CONDITION_LOW_VOLATILITY:
         volatility_multiplier = 0.8;  // Tighter stops in low volatility
         break;
      case MARKET_CONDITION_HIGH_VOLATILITY:
         volatility_multiplier = 1.3;  // Wider stops in high volatility
         break;
      case MARKET_CONDITION_EXTREME_VOLATILITY:
         volatility_multiplier = 1.6;  // Much wider stops in extreme volatility
         break;
      default:  // MARKET_CONDITION_NORMAL_VOLATILITY
         volatility_multiplier = 1.0;
         break;
     }

   //--- Optimize stop loss and take profit
   m_opt_stop_loss = m_base_stop_loss * volatility_multiplier;
   m_opt_take_profit = m_base_take_profit * volatility_multiplier;

   //--- Optimize RSI parameters
   if(m_is_trending)
     {
      // In trending markets, use more sensitive RSI
      m_opt_rsi_period = MathMax(14, m_base_rsi_period - 3);
      m_opt_rsi_overbought = MathMin(80, m_base_rsi_overbought + 5);
      m_opt_rsi_oversold = MathMax(20, m_base_rsi_oversold - 5);
     }
   else
     {
      // In ranging markets, use less sensitive RSI
      m_opt_rsi_period = MathMin(28, m_base_rsi_period + 3);
      m_opt_rsi_overbought = MathMax(70, m_base_rsi_overbought - 5);
      m_opt_rsi_oversold = MathMin(30, m_base_rsi_oversold + 5);
     }

   //--- Ensure reasonable bounds
   m_opt_stop_loss = MathMax(50, MathMin(300, m_opt_stop_loss));
   m_opt_take_profit = MathMax(100, MathMin(600, m_opt_take_profit));
   m_opt_rsi_period = MathMax(8, MathMin(32, m_opt_rsi_period));
   m_opt_rsi_overbought = MathMax(65, MathMin(85, m_opt_rsi_overbought));
   m_opt_rsi_oversold = MathMax(15, MathMin(35, m_opt_rsi_oversold));
  }

//+------------------------------------------------------------------+
//| Set base parameters                                              |
//+------------------------------------------------------------------+
void CGoldOptimizer::SetBaseParameters(double sl, double tp, int rsi_period, int rsi_ob, int rsi_os)
  {
   m_base_stop_loss = sl;
   m_base_take_profit = tp;
   m_base_rsi_period = rsi_period;
   m_base_rsi_overbought = rsi_ob;
   m_base_rsi_oversold = rsi_os;

   //--- Update optimized parameters
   OptimizeParameters();
  }
//+------------------------------------------------------------------+
