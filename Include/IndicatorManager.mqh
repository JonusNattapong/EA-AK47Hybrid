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
   int               m_atr_handle;
   int               m_macd_handle;
   int               m_stoch_handle;
   int               m_sma_fast_handle;
   int               m_sma_slow_handle;
   int               m_bb_handle;
   int               m_adx_handle;
   int               m_momentum_handle;
   double            m_rsi_buffer[];
   double            m_ema_buffer[];
   double            m_atr_buffer[];
   double            m_macd_main_buffer[];
   double            m_macd_signal_buffer[];
   double            m_stoch_main_buffer[];
   double            m_stoch_signal_buffer[];
   double            m_sma_fast_buffer[];
   double            m_sma_slow_buffer[];
   double            m_bb_upper_buffer[];
   double            m_bb_lower_buffer[];
   double            m_adx_buffer[];
   double            m_momentum_buffer[];

   string            m_symbol;
   ENUM_TIMEFRAMES   m_timeframe;
   int               m_rsi_period;
   int               m_ema_period;
   int               m_atr_period;
   int               m_macd_fast;
   int               m_macd_slow;
   int               m_macd_signal;
   int               m_stoch_k;
   int               m_stoch_d;
   int               m_stoch_slowing;
   int               m_sma_fast_period;
   int               m_sma_slow_period;
   int               m_bb_period;
   double            m_bb_deviation;
   int               m_adx_period;
   int               m_momentum_period;

public:
                     CIndicatorManager();
                    ~CIndicatorManager();

   bool              Init(string symbol, ENUM_TIMEFRAMES timeframe, int rsi_period, int ema_period, int atr_period, int macd_fast = 12, int macd_slow = 26, int macd_signal = 9, int sma_fast = 10, int sma_slow = 20, int bb_period = 20, double bb_deviation = 2.0, int adx_period = 14, int momentum_period = 14);
   void              Deinit();

   bool              Update();
   double            GetRSI() { return m_rsi_buffer[0]; }
   double            GetEMA() { return m_ema_buffer[0]; }
   double            GetATR() { return m_atr_buffer[0]; }
   double            GetMACDMain() { return m_macd_main_buffer[0]; }
   double            GetMACDSignal() { return m_macd_signal_buffer[0]; }
   double            GetStochMain() { return m_stoch_main_buffer[0]; }
   double            GetStochSignal() { return m_stoch_signal_buffer[0]; }
   double            GetSMAFast() { return m_sma_fast_buffer[0]; }
   double            GetSMASlow() { return m_sma_slow_buffer[0]; }
   double            GetBBUpper() { return m_bb_upper_buffer[0]; }
   double            GetBBLower() { return m_bb_lower_buffer[0]; }
   double            GetADX() { return m_adx_buffer[0]; }
   double            GetMomentum() { return m_momentum_buffer[0]; }

   bool              IsRSIOversold(int oversold_level);
   bool              IsRSIOverbought(int overbought_level);
   bool              IsPriceAboveEMA(double price);
   bool              IsPriceBelowEMA(double price);
   bool              IsBullishMACrossover();
   bool              IsBearishMACrossover();
   bool              IsPriceAboveBBUpper(double price);
   bool              IsPriceBelowBBLower(double price);
   bool              IsADXTrending(int threshold = 25);
  };

//+------------------------------------------------------------------+
//| Constructor                                                       |
//+------------------------------------------------------------------+
CIndicatorManager::CIndicatorManager()
  {
   m_rsi_handle = INVALID_HANDLE;
   m_ema_handle = INVALID_HANDLE;
   m_atr_handle = INVALID_HANDLE;
   m_macd_handle = INVALID_HANDLE;
   m_stoch_handle = INVALID_HANDLE;
   m_sma_fast_handle = INVALID_HANDLE;
   m_sma_slow_handle = INVALID_HANDLE;
   m_bb_handle = INVALID_HANDLE;
   m_adx_handle = INVALID_HANDLE;
   m_momentum_handle = INVALID_HANDLE;
   ArraySetAsSeries(m_rsi_buffer, true);
   ArraySetAsSeries(m_ema_buffer, true);
   ArraySetAsSeries(m_atr_buffer, true);
   ArraySetAsSeries(m_macd_main_buffer, true);
   ArraySetAsSeries(m_macd_signal_buffer, true);
   ArraySetAsSeries(m_stoch_main_buffer, true);
   ArraySetAsSeries(m_stoch_signal_buffer, true);
   ArraySetAsSeries(m_sma_fast_buffer, true);
   ArraySetAsSeries(m_sma_slow_buffer, true);
   ArraySetAsSeries(m_bb_upper_buffer, true);
   ArraySetAsSeries(m_bb_lower_buffer, true);
   ArraySetAsSeries(m_adx_buffer, true);
   ArraySetAsSeries(m_momentum_buffer, true);
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
bool CIndicatorManager::Init(string symbol, ENUM_TIMEFRAMES timeframe, int rsi_period, int ema_period, int atr_period, int macd_fast = 12, int macd_slow = 26, int macd_signal = 9, int sma_fast = 10, int sma_slow = 20, int bb_period = 20, double bb_deviation = 2.0, int adx_period = 14, int momentum_period = 14)
  {
   m_symbol = symbol;
   m_timeframe = timeframe;
   m_rsi_period = rsi_period;
   m_ema_period = ema_period;
   m_atr_period = atr_period;
   m_macd_fast = macd_fast;
   m_macd_slow = macd_slow;
   m_macd_signal = macd_signal;
   m_stoch_k = 5;
   m_stoch_d = 3;
   m_stoch_slowing = 3;
   m_sma_fast_period = sma_fast;
   m_sma_slow_period = sma_slow;
   m_bb_period = bb_period;
   m_bb_deviation = bb_deviation;
   m_adx_period = adx_period;
   m_momentum_period = momentum_period;

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

   // Create ATR indicator
   m_atr_handle = iATR(m_symbol, m_timeframe, m_atr_period);
   if(m_atr_handle == INVALID_HANDLE)
     {
      Print("Error creating ATR indicator: ", GetLastError());
      IndicatorRelease(m_rsi_handle);
      IndicatorRelease(m_ema_handle);
      return false;
     }

   // Create MACD indicator
   m_macd_handle = iMACD(m_symbol, m_timeframe, m_macd_fast, m_macd_slow, m_macd_signal, PRICE_CLOSE);
   if(m_macd_handle == INVALID_HANDLE)
     {
      Print("Error creating MACD indicator: ", GetLastError());
      IndicatorRelease(m_rsi_handle);
      IndicatorRelease(m_ema_handle);
      IndicatorRelease(m_atr_handle);
      return false;
     }

   // Create Stochastic indicator
   m_stoch_handle = iStochastic(m_symbol, m_timeframe, m_stoch_k, m_stoch_d, m_stoch_slowing, MODE_SMA, STO_LOWHIGH);
   if(m_stoch_handle == INVALID_HANDLE)
     {
      Print("Error creating Stochastic indicator: ", GetLastError());
      IndicatorRelease(m_rsi_handle);
      IndicatorRelease(m_ema_handle);
      IndicatorRelease(m_atr_handle);
      IndicatorRelease(m_macd_handle);
      return false;
     }

   // Create SMA fast indicator
   m_sma_fast_handle = iMA(m_symbol, m_timeframe, m_sma_fast_period, 0, MODE_SMA, PRICE_CLOSE);
   if(m_sma_fast_handle == INVALID_HANDLE)
     {
      Print("Error creating SMA fast indicator: ", GetLastError());
      IndicatorRelease(m_rsi_handle);
      IndicatorRelease(m_ema_handle);
      IndicatorRelease(m_atr_handle);
      IndicatorRelease(m_macd_handle);
      IndicatorRelease(m_stoch_handle);
      return false;
     }

   // Create SMA slow indicator
   m_sma_slow_handle = iMA(m_symbol, m_timeframe, m_sma_slow_period, 0, MODE_SMA, PRICE_CLOSE);
   if(m_sma_slow_handle == INVALID_HANDLE)
     {
      Print("Error creating SMA slow indicator: ", GetLastError());
      IndicatorRelease(m_rsi_handle);
      IndicatorRelease(m_ema_handle);
      IndicatorRelease(m_atr_handle);
      IndicatorRelease(m_macd_handle);
      IndicatorRelease(m_stoch_handle);
      IndicatorRelease(m_sma_fast_handle);
      return false;
     }

   // Create Bollinger Bands indicator
   m_bb_handle = iBands(m_symbol, m_timeframe, m_bb_period, 0, m_bb_deviation, PRICE_CLOSE);
   if(m_bb_handle == INVALID_HANDLE)
     {
      Print("Error creating Bollinger Bands indicator: ", GetLastError());
      IndicatorRelease(m_rsi_handle);
      IndicatorRelease(m_ema_handle);
      IndicatorRelease(m_atr_handle);
      IndicatorRelease(m_macd_handle);
      IndicatorRelease(m_stoch_handle);
      IndicatorRelease(m_sma_fast_handle);
      IndicatorRelease(m_sma_slow_handle);
      return false;
     }

   // Create ADX indicator
   m_adx_handle = iADX(m_symbol, m_timeframe, m_adx_period);
   if(m_adx_handle == INVALID_HANDLE)
     {
      Print("Error creating ADX indicator: ", GetLastError());
      IndicatorRelease(m_rsi_handle);
      IndicatorRelease(m_ema_handle);
      IndicatorRelease(m_atr_handle);
      IndicatorRelease(m_macd_handle);
      IndicatorRelease(m_stoch_handle);
      IndicatorRelease(m_sma_fast_handle);
      IndicatorRelease(m_sma_slow_handle);
      IndicatorRelease(m_bb_handle);
      return false;
     }

   // Create Momentum indicator
   m_momentum_handle = iMomentum(m_symbol, m_timeframe, m_momentum_period, PRICE_CLOSE);
   if(m_momentum_handle == INVALID_HANDLE)
     {
      Print("Error creating Momentum indicator: ", GetLastError());
      IndicatorRelease(m_rsi_handle);
      IndicatorRelease(m_ema_handle);
      IndicatorRelease(m_atr_handle);
      IndicatorRelease(m_macd_handle);
      IndicatorRelease(m_stoch_handle);
      IndicatorRelease(m_sma_fast_handle);
      IndicatorRelease(m_sma_slow_handle);
      IndicatorRelease(m_bb_handle);
      IndicatorRelease(m_adx_handle);
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
   if(m_atr_handle != INVALID_HANDLE)
      IndicatorRelease(m_atr_handle);
   if(m_macd_handle != INVALID_HANDLE)
      IndicatorRelease(m_macd_handle);
   if(m_stoch_handle != INVALID_HANDLE)
      IndicatorRelease(m_stoch_handle);
   if(m_sma_fast_handle != INVALID_HANDLE)
      IndicatorRelease(m_sma_fast_handle);
   if(m_sma_slow_handle != INVALID_HANDLE)
      IndicatorRelease(m_sma_slow_handle);
   if(m_bb_handle != INVALID_HANDLE)
      IndicatorRelease(m_bb_handle);
   if(m_adx_handle != INVALID_HANDLE)
      IndicatorRelease(m_adx_handle);
   if(m_momentum_handle != INVALID_HANDLE)
      IndicatorRelease(m_momentum_handle);
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

   // Copy ATR buffer
   if(CopyBuffer(m_atr_handle, 0, 0, 1, m_atr_buffer) != 1)
     {
      Print("Error copying ATR buffer: ", GetLastError());
      return false;
     }

   // Copy MACD main buffer
   if(CopyBuffer(m_macd_handle, 0, 0, 1, m_macd_main_buffer) != 1)
     {
      Print("Error copying MACD main buffer: ", GetLastError());
      return false;
     }

   // Copy MACD signal buffer
   if(CopyBuffer(m_macd_handle, 1, 0, 1, m_macd_signal_buffer) != 1)
     {
      Print("Error copying MACD signal buffer: ", GetLastError());
      return false;
     }

   // Copy Stochastic main buffer
   if(CopyBuffer(m_stoch_handle, 0, 0, 1, m_stoch_main_buffer) != 1)
     {
      Print("Error copying Stochastic main buffer: ", GetLastError());
      return false;
     }

   // Copy Stochastic signal buffer
   if(CopyBuffer(m_stoch_handle, 1, 0, 1, m_stoch_signal_buffer) != 1)
     {
      Print("Error copying Stochastic signal buffer: ", GetLastError());
      return false;
     }

   // Copy SMA fast buffer
   if(CopyBuffer(m_sma_fast_handle, 0, 0, 1, m_sma_fast_buffer) != 1)
     {
      Print("Error copying SMA fast buffer: ", GetLastError());
      return false;
     }

   // Copy SMA slow buffer
   if(CopyBuffer(m_sma_slow_handle, 0, 0, 1, m_sma_slow_buffer) != 1)
     {
      Print("Error copying SMA slow buffer: ", GetLastError());
      return false;
     }

   // Copy Bollinger Bands upper buffer
   if(CopyBuffer(m_bb_handle, 1, 0, 1, m_bb_upper_buffer) != 1)
     {
      Print("Error copying BB upper buffer: ", GetLastError());
      return false;
     }

   // Copy Bollinger Bands lower buffer
   if(CopyBuffer(m_bb_handle, 2, 0, 1, m_bb_lower_buffer) != 1)
     {
      Print("Error copying BB lower buffer: ", GetLastError());
      return false;
     }

   // Copy ADX buffer
   if(CopyBuffer(m_adx_handle, 0, 0, 1, m_adx_buffer) != 1)
     {
      Print("Error copying ADX buffer: ", GetLastError());
      return false;
     }

   // Copy Momentum buffer
   if(CopyBuffer(m_momentum_handle, 0, 0, 1, m_momentum_buffer) != 1)
     {
      Print("Error copying Momentum buffer: ", GetLastError());
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
//| Check for bullish MA crossover                                    |
//+------------------------------------------------------------------+
bool CIndicatorManager::IsBullishMACrossover()
  {
   double fast_prev = m_sma_fast_buffer[1];
   double slow_prev = m_sma_slow_buffer[1];
   double fast_curr = m_sma_fast_buffer[0];
   double slow_curr = m_sma_slow_buffer[0];
   return (fast_prev <= slow_prev && fast_curr > slow_curr);
  }

//+------------------------------------------------------------------+
//| Check for bearish MA crossover                                    |
//+------------------------------------------------------------------+
bool CIndicatorManager::IsBearishMACrossover()
  {
   double fast_prev = m_sma_fast_buffer[1];
   double slow_prev = m_sma_slow_buffer[1];
   double fast_curr = m_sma_fast_buffer[0];
   double slow_curr = m_sma_slow_buffer[0];
   return (fast_prev >= slow_prev && fast_curr < slow_curr);
  }

//+------------------------------------------------------------------+
//| Check if price is above BB upper band                            |
//+------------------------------------------------------------------+
bool CIndicatorManager::IsPriceAboveBBUpper(double price)
  {
   return (price > m_bb_upper_buffer[0]);
  }

//+------------------------------------------------------------------+
//| Check if price is below BB lower band                            |
//+------------------------------------------------------------------+
bool CIndicatorManager::IsPriceBelowBBLower(double price)
  {
   return (price < m_bb_lower_buffer[0]);
  }

//+------------------------------------------------------------------+
//| Check if ADX indicates trending                                  |
//+------------------------------------------------------------------+
bool CIndicatorManager::IsADXTrending(int threshold)
  {
   return (m_adx_buffer[0] > threshold);
  }
//+------------------------------------------------------------------+
