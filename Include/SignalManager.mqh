//+------------------------------------------------------------------+
//|                                                SignalManager.mqh |
//|                        Copyright 2025, zombitx64 |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"

#include "IndicatorManager.mqh"

//+------------------------------------------------------------------+
//| Signal Types Enumeration                                         |
//+------------------------------------------------------------------+
enum ENUM_SIGNAL_TYPE
  {
   SIGNAL_NONE = 0,      // No signal
   SIGNAL_BUY = 1,       // Buy signal
   SIGNAL_SELL = -1      // Sell signal
  };

//+------------------------------------------------------------------+
//| Signal Manager Class                                             |
//+------------------------------------------------------------------+
class CSignalManager
  {
private:
   CIndicatorManager *m_indicator_manager;

   int               m_rsi_oversold;
   int               m_rsi_overbought;
   bool              m_use_trend_filter;
   bool              m_use_atr_filter;
   double            m_min_atr;
   bool              m_use_macd_filter;
   bool              m_use_stoch_filter;
   int               m_stoch_overbought;
   int               m_stoch_oversold;
   bool              m_use_ma_crossover;
   bool              m_use_breakout;
   bool              m_use_momentum_filter;
   bool              m_use_adx_filter;
   int               m_adx_threshold;

   string            m_symbol;

public:
                     CSignalManager();
                    ~CSignalManager();

   void              Init(CIndicatorManager *indicator_manager,
                          int rsi_oversold,
                          int rsi_overbought,
                          bool use_trend_filter,
                          bool use_atr_filter,
                          double min_atr,
                          bool use_macd_filter,
                          bool use_stoch_filter,
                          int stoch_overbought,
                          int stoch_oversold,
                          string symbol,
                          bool use_ma_crossover = false,
                          bool use_breakout = false,
                          bool use_momentum_filter = false,
                          bool use_adx_filter = false,
                          int adx_threshold = 25);

   ENUM_SIGNAL_TYPE  GetSignal();
   bool              IsBuySignal();
   bool              IsSellSignal();

   void              SetRSIOversold(int value) { m_rsi_oversold = value; }
   void              SetRSIOverbought(int value) { m_rsi_overbought = value; }
   void              SetUseTrendFilter(bool value) { m_use_trend_filter = value; }

   double            GetRSI() { return m_indicator_manager != NULL ? m_indicator_manager.GetRSI() : 0.0; }
   double            GetEMA() { return m_indicator_manager != NULL ? m_indicator_manager.GetEMA() : 0.0; }
   double            GetATR() { return m_indicator_manager != NULL ? m_indicator_manager.GetATR() : 0.0; }
   double            GetMACDMain() { return m_indicator_manager != NULL ? m_indicator_manager.GetMACDMain() : 0.0; }
   double            GetMACDSignal() { return m_indicator_manager != NULL ? m_indicator_manager.GetMACDSignal() : 0.0; }
   double            GetStochMain() { return m_indicator_manager != NULL ? m_indicator_manager.GetStochMain() : 0.0; }
   double            GetStochSignal() { return m_indicator_manager != NULL ? m_indicator_manager.GetStochSignal() : 0.0; }
   double            GetSMAFast() { return m_indicator_manager != NULL ? m_indicator_manager.GetSMAFast() : 0.0; }
   double            GetSMASlow() { return m_indicator_manager != NULL ? m_indicator_manager.GetSMASlow() : 0.0; }
   double            GetBBUpper() { return m_indicator_manager != NULL ? m_indicator_manager.GetBBUpper() : 0.0; }
   double            GetBBLower() { return m_indicator_manager != NULL ? m_indicator_manager.GetBBLower() : 0.0; }
   double            GetADX() { return m_indicator_manager != NULL ? m_indicator_manager.GetADX() : 0.0; }
   double            GetMomentum() { return m_indicator_manager != NULL ? m_indicator_manager.GetMomentum() : 0.0; }

   bool              IsStochOversold(int level);
   bool              IsStochOverbought(int level);
};

//+------------------------------------------------------------------+
//| Constructor                                                       |
//+------------------------------------------------------------------+
CSignalManager::CSignalManager()
  {
   m_indicator_manager = NULL;
   m_rsi_oversold = 30;
   m_rsi_overbought = 70;
   m_use_trend_filter = true;
   m_use_atr_filter = true;
   m_min_atr = 0.5;
   m_use_macd_filter = true;
   m_use_stoch_filter = true;
   m_stoch_overbought = 80;
   m_stoch_oversold = 20;
   m_use_ma_crossover = false;
   m_use_breakout = false;
   m_use_momentum_filter = false;
   m_use_adx_filter = false;
   m_adx_threshold = 25;
   m_symbol = "";
  }

//+------------------------------------------------------------------+
//| Destructor                                                        |
//+------------------------------------------------------------------+
CSignalManager::~CSignalManager()
  {
  }

//+------------------------------------------------------------------+
//| Initialize signal manager                                         |
//+------------------------------------------------------------------+
void CSignalManager::Init(CIndicatorManager *indicator_manager,
                          int rsi_oversold,
                          int rsi_overbought,
                          bool use_trend_filter,
                          bool use_atr_filter,
                          double min_atr,
                          bool use_macd_filter,
                          bool use_stoch_filter,
                          int stoch_overbought,
                          int stoch_oversold,
                          string symbol,
                          bool use_ma_crossover,
                          bool use_breakout,
                          bool use_momentum_filter,
                          bool use_adx_filter,
                          int adx_threshold)
  {
   m_indicator_manager = indicator_manager;
   m_rsi_oversold = rsi_oversold;
   m_rsi_overbought = rsi_overbought;
   m_use_trend_filter = use_trend_filter;
   m_use_atr_filter = use_atr_filter;
   m_min_atr = min_atr;
   m_use_macd_filter = use_macd_filter;
   m_use_stoch_filter = use_stoch_filter;
   m_stoch_overbought = stoch_overbought;
   m_stoch_oversold = stoch_oversold;
   m_use_ma_crossover = use_ma_crossover;
   m_use_breakout = use_breakout;
   m_use_momentum_filter = use_momentum_filter;
   m_use_adx_filter = use_adx_filter;
   m_adx_threshold = adx_threshold;
   m_symbol = symbol;

   Print("Signal Manager initialized - RSI Oversold: ", m_rsi_oversold,
         " | RSI Overbought: ", m_rsi_overbought,
         " | Trend Filter: ", (m_use_trend_filter ? "Enabled" : "Disabled"),
         " | ATR Filter: ", (m_use_atr_filter ? "Enabled" : "Disabled"), " | Min ATR: ", DoubleToString(m_min_atr, 2),
         " | MACD Filter: ", (m_use_macd_filter ? "Enabled" : "Disabled"),
         " | Stoch Filter: ", (m_use_stoch_filter ? "Enabled" : "Disabled"), " | Stoch OB: ", m_stoch_overbought, " | Stoch OS: ", m_stoch_oversold,
         " | MA Crossover: ", (m_use_ma_crossover ? "Enabled" : "Disabled"),
         " | Breakout: ", (m_use_breakout ? "Enabled" : "Disabled"),
         " | Momentum Filter: ", (m_use_momentum_filter ? "Enabled" : "Disabled"),
         " | ADX Filter: ", (m_use_adx_filter ? "Enabled" : "Disabled"), " | ADX Threshold: ", m_adx_threshold);
  }

//+------------------------------------------------------------------+
//| Get trading signal                                                |
//+------------------------------------------------------------------+
ENUM_SIGNAL_TYPE CSignalManager::GetSignal()
  {
   if(m_indicator_manager == NULL)
     {
      Print("Error: Indicator Manager not initialized");
      return SIGNAL_NONE;
     }

   if(IsBuySignal())
      return SIGNAL_BUY;

   if(IsSellSignal())
      return SIGNAL_SELL;

   return SIGNAL_NONE;
  }

//+------------------------------------------------------------------+
//| Check for buy signal                                              |
//+------------------------------------------------------------------+
bool CSignalManager::IsBuySignal()
  {
   if(m_indicator_manager == NULL)
      return false;

   bool signal_found = false;

   // RSI-based signal
   if(m_indicator_manager.IsRSIOversold(m_rsi_oversold))
     {
      signal_found = true;
     }

   // MA Crossover signal
   if(m_use_ma_crossover && m_indicator_manager.IsBullishMACrossover())
     {
      signal_found = true;
     }

   // Breakout signal
   if(m_use_breakout)
     {
      double ask = SymbolInfoDouble(m_symbol, SYMBOL_ASK);
      if(m_indicator_manager.IsPriceAboveBBUpper(ask))
        {
         signal_found = true;
        }
     }

   if(!signal_found)
      return false;

   // If trend filter is enabled, check if price is above EMA
   if(m_use_trend_filter)
     {
      double ask = SymbolInfoDouble(m_symbol, SYMBOL_ASK);
      if(!m_indicator_manager.IsPriceAboveEMA(ask))
        {
         return false;
        }
     }

   // If ATR filter is enabled, check minimum volatility
   if(m_use_atr_filter && m_indicator_manager.GetATR() < m_min_atr)
      return false;

   // If MACD filter is enabled, check bullish momentum
   if(m_use_macd_filter && m_indicator_manager.GetMACDMain() <= m_indicator_manager.GetMACDSignal())
      return false;

   // If Stochastic filter is enabled, check oversold
   if(m_use_stoch_filter && !IsStochOversold(m_stoch_oversold))
      return false;

   // If Momentum filter is enabled, check positive momentum
   if(m_use_momentum_filter && m_indicator_manager.GetMomentum() <= 100.0)
      return false;

   // If ADX filter is enabled, check trending
   if(m_use_adx_filter && !m_indicator_manager.IsADXTrending(m_adx_threshold))
      return false;

   return true;
  }

//+------------------------------------------------------------------+
//| Check for sell signal                                             |
//+------------------------------------------------------------------+
//| Check if Stochastic is oversold                                  |
//+------------------------------------------------------------------+
bool CSignalManager::IsStochOversold(int level)
  {
   return (m_indicator_manager.GetStochMain() < level);
  }

//+------------------------------------------------------------------+
//| Check if Stochastic is overbought                                |
//+------------------------------------------------------------------+
bool CSignalManager::IsStochOverbought(int level)
  {
   return (m_indicator_manager.GetStochMain() > level);
  }
//+------------------------------------------------------------------+
bool CSignalManager::IsSellSignal()
  {
   if(m_indicator_manager == NULL)
      return false;

   bool signal_found = false;

   // RSI-based signal
   if(m_indicator_manager.IsRSIOverbought(m_rsi_overbought))
     {
      signal_found = true;
     }

   // MA Crossover signal
   if(m_use_ma_crossover && m_indicator_manager.IsBearishMACrossover())
     {
      signal_found = true;
     }

   // Breakout signal
   if(m_use_breakout)
     {
      double bid = SymbolInfoDouble(m_symbol, SYMBOL_BID);
      if(m_indicator_manager.IsPriceBelowBBLower(bid))
        {
         signal_found = true;
        }
     }

   if(!signal_found)
      return false;

   // If trend filter is enabled, check if price is below EMA
   if(m_use_trend_filter)
     {
      double bid = SymbolInfoDouble(m_symbol, SYMBOL_BID);
      if(!m_indicator_manager.IsPriceBelowEMA(bid))
        {
         return false;
        }
     }

   // If ATR filter is enabled, check minimum volatility
   if(m_use_atr_filter && m_indicator_manager.GetATR() < m_min_atr)
      return false;

   // If MACD filter is enabled, check bearish momentum
   if(m_use_macd_filter && m_indicator_manager.GetMACDMain() >= m_indicator_manager.GetMACDSignal())
      return false;

   // If Stochastic filter is enabled, check overbought
   if(m_use_stoch_filter && !IsStochOverbought(m_stoch_overbought))
      return false;

   // If Momentum filter is enabled, check negative momentum
   if(m_use_momentum_filter && m_indicator_manager.GetMomentum() >= 100.0)
      return false;

   // If ADX filter is enabled, check trending
   if(m_use_adx_filter && !m_indicator_manager.IsADXTrending(m_adx_threshold))
      return false;

   return true;
  }
//+------------------------------------------------------------------+
