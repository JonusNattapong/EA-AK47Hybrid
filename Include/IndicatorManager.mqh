//+------------------------------------------------------------------+
//|                                             IndicatorManager.mqh |
//|                        Copyright 2025, zombitx64 |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"

//+------------------------------------------------------------------+
//| Indicator Manager Class                                          |
//+------------------------------------------------------------------+
class CIndicatorManager
  {
private:
   int               m_rsi_handle;
   int               m_ema_handle;
   double            m_rsi_buffer[];
   double            m_ema_buffer[];

   string            m_symbol;
   ENUM_TIMEFRAMES   m_timeframe;
   int               m_rsi_period;
   int               m_ema_period;

public:
                     CIndicatorManager();
                    ~CIndicatorManager();

   bool              Init(string symbol, ENUM_TIMEFRAMES timeframe, int rsi_period, int ema_period);
   void              Deinit();

   bool              Update();
   double            GetRSI() { return m_rsi_buffer[0]; }
   double            GetEMA() { return m_ema_buffer[0]; }

   bool              IsRSIOversold(int oversold_level);
   bool              IsRSIOverbought(int overbought_level);
   bool              IsPriceAboveEMA(double price);
   bool              IsPriceBelowEMA(double price);
  };

//+------------------------------------------------------------------+
//| Constructor                                                       |
//+------------------------------------------------------------------+
CIndicatorManager::CIndicatorManager()
  {
   m_rsi_handle = INVALID_HANDLE;
   m_ema_handle = INVALID_HANDLE;
   ArraySetAsSeries(m_rsi_buffer, true);
   ArraySetAsSeries(m_ema_buffer, true);
  }

//+------------------------------------------------------------------+
//| Destructor                                                        |
//+------------------------------------------------------------------+
CIndicatorManager::~CIndicatorManager()
  {
   Deinit();
  }

//+------------------------------------------------------------------+
//| Initialize indicators                                             |
//+------------------------------------------------------------------+
bool CIndicatorManager::Init(string symbol, ENUM_TIMEFRAMES timeframe, int rsi_period, int ema_period)
  {
   m_symbol = symbol;
   m_timeframe = timeframe;
   m_rsi_period = rsi_period;
   m_ema_period = ema_period;

   // Create RSI indicator
   m_rsi_handle = iRSI(m_symbol, m_timeframe, m_rsi_period, PRICE_CLOSE);
   if(m_rsi_handle == INVALID_HANDLE)
     {
      Print("Error creating RSI indicator: ", GetLastError());
      return false;
     }

   // Create EMA indicator
   m_ema_handle = iMA(m_symbol, m_timeframe, m_ema_period, 0, MODE_EMA, PRICE_CLOSE);
   if(m_ema_handle == INVALID_HANDLE)
     {
      Print("Error creating EMA indicator: ", GetLastError());
      IndicatorRelease(m_rsi_handle);
      return false;
     }

   Print("Indicators initialized successfully");
   return true;
  }

//+------------------------------------------------------------------+
//| Deinitialize indicators                                           |
//+------------------------------------------------------------------+
void CIndicatorManager::Deinit()
  {
   if(m_rsi_handle != INVALID_HANDLE)
      IndicatorRelease(m_rsi_handle);
   if(m_ema_handle != INVALID_HANDLE)
      IndicatorRelease(m_ema_handle);
  }

//+------------------------------------------------------------------+
//| Update indicator buffers                                          |
//+------------------------------------------------------------------+
bool CIndicatorManager::Update()
  {
   // Copy RSI buffer
   if(CopyBuffer(m_rsi_handle, 0, 0, 1, m_rsi_buffer) != 1)
     {
      Print("Error copying RSI buffer: ", GetLastError());
      return false;
     }

   // Copy EMA buffer
   if(CopyBuffer(m_ema_handle, 0, 0, 1, m_ema_buffer) != 1)
     {
      Print("Error copying EMA buffer: ", GetLastError());
      return false;
     }

   return true;
  }

//+------------------------------------------------------------------+
//| Check if RSI is oversold                                          |
//+------------------------------------------------------------------+
bool CIndicatorManager::IsRSIOversold(int oversold_level)
  {
   return (m_rsi_buffer[0] < oversold_level);
  }

//+------------------------------------------------------------------+
//| Check if RSI is overbought                                        |
//+------------------------------------------------------------------+
bool CIndicatorManager::IsRSIOverbought(int overbought_level)
  {
   return (m_rsi_buffer[0] > overbought_level);
  }

//+------------------------------------------------------------------+
//| Check if price is above EMA                                       |
//+------------------------------------------------------------------+
bool CIndicatorManager::IsPriceAboveEMA(double price)
  {
   return (price > m_ema_buffer[0]);
  }

//+------------------------------------------------------------------+
//| Check if price is below EMA                                       |
//+------------------------------------------------------------------+
bool CIndicatorManager::IsPriceBelowEMA(double price)
  {
   return (price < m_ema_buffer[0]);
  }
//+------------------------------------------------------------------+
