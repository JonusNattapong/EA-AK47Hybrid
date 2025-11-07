//+------------------------------------------------------------------+
//|                                                SignalManager.mqh |
//|                        Copyright 2023, MetaQuotes Software Corp. |
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

   string            m_symbol;

public:
                     CSignalManager();
                    ~CSignalManager();

   void              Init(CIndicatorManager *indicator_manager,
                          int rsi_oversold,
                          int rsi_overbought,
                          bool use_trend_filter,
                          string symbol);

   ENUM_SIGNAL_TYPE  GetSignal();
   bool              IsBuySignal();
   bool              IsSellSignal();

   void              SetRSIOversold(int value) { m_rsi_oversold = value; }
   void              SetRSIOverbought(int value) { m_rsi_overbought = value; }
   void              SetUseTrendFilter(bool value) { m_use_trend_filter = value; }
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
                          string symbol)
  {
   m_indicator_manager = indicator_manager;
   m_rsi_oversold = rsi_oversold;
   m_rsi_overbought = rsi_overbought;
   m_use_trend_filter = use_trend_filter;
   m_symbol = symbol;

   Print("Signal Manager initialized - RSI Oversold: ", m_rsi_oversold,
         " | RSI Overbought: ", m_rsi_overbought,
         " | Trend Filter: ", (m_use_trend_filter ? "Enabled" : "Disabled"));
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

   // RSI is oversold
   if(!m_indicator_manager.IsRSIOversold(m_rsi_oversold))
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

   return true;
  }

//+------------------------------------------------------------------+
//| Check for sell signal                                             |
//+------------------------------------------------------------------+
bool CSignalManager::IsSellSignal()
  {
   if(m_indicator_manager == NULL)
      return false;

   // RSI is overbought
   if(!m_indicator_manager.IsRSIOverbought(m_rsi_overbought))
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

   return true;
  }
//+------------------------------------------------------------------+
