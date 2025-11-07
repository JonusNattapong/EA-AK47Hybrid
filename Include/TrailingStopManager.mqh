//+------------------------------------------------------------------+
//|                                           TrailingStopManager.mqh |
//|                        Copyright 2023, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"

//--- Include necessary libraries
#include <Trade\PositionInfo.mqh>
#include <Trade\Trade.mqh>

//--- Enums
enum ENUM_TRAILING_MODE
  {
   TRAILING_MODE_FIXED,     // Fixed trailing distance
   TRAILING_MODE_PERCENT,   // Percentage-based trailing
   TRAILING_MODE_ATR        // ATR-based trailing
  };

//+------------------------------------------------------------------+
//| Class CTrailingStopManager                                       |
//| Purpose: Manages trailing stop functionality                     |
//+------------------------------------------------------------------+
class CTrailingStopManager
  {
private:
   CPositionInfo      m_position_info;
   CTrade             m_trade;

   string             m_symbol;
   int                m_magic_number;
   bool               m_enabled;
   ENUM_TRAILING_MODE m_mode;
   double             m_trailing_distance;    // In points or percentage
   double             m_trailing_step;        // Minimum step to move SL (points)
   int                m_atr_period;           // ATR period for ATR mode
   double             m_atr_multiplier;       // ATR multiplier for ATR mode

   //--- Internal methods
   bool               ApplyTrailingStop(ulong ticket, double current_price, double current_sl);
   double             CalculateTrailingLevel(double entry_price, double current_price, ENUM_POSITION_TYPE pos_type);
   double             GetATRValue();

public:
   //--- Constructor/Destructor
                     CTrailingStopManager();
                    ~CTrailingStopManager();

   //--- Initialization
   bool               Init(string symbol, int magic_number, bool enabled = true,
                          ENUM_TRAILING_MODE mode = TRAILING_MODE_FIXED,
                          double trailing_distance = 20.0, double trailing_step = 5.0,
                          int atr_period = 14, double atr_multiplier = 1.5);

   //--- Main methods
   void               ProcessTrailingStops();
   bool               IsEnabled() { return m_enabled; }

   //--- Setters
   void               SetEnabled(bool enabled) { m_enabled = enabled; }
   void               SetMode(ENUM_TRAILING_MODE mode) { m_mode = mode; }
   void               SetTrailingDistance(double distance) { m_trailing_distance = distance; }
   void               SetTrailingStep(double step) { m_trailing_step = step; }
   void               SetATRPeriod(int period) { m_atr_period = period; }
   void               SetATRMultiplier(double multiplier) { m_atr_multiplier = multiplier; }
  };

//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CTrailingStopManager::CTrailingStopManager()
  {
   m_symbol = "";
   m_magic_number = 0;
   m_enabled = false;
   m_mode = TRAILING_MODE_FIXED;
   m_trailing_distance = 20.0;
   m_trailing_step = 5.0;
   m_atr_period = 14;
   m_atr_multiplier = 1.5;
  }

//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CTrailingStopManager::~CTrailingStopManager()
  {
  }

//+------------------------------------------------------------------+
//| Initialize the trailing stop manager                             |
//+------------------------------------------------------------------+
bool CTrailingStopManager::Init(string symbol, int magic_number, bool enabled = true,
                               ENUM_TRAILING_MODE mode = TRAILING_MODE_FIXED,
                               double trailing_distance = 20.0, double trailing_step = 5.0,
                               int atr_period = 14, double atr_multiplier = 1.5)
  {
   m_symbol = symbol;
   m_magic_number = magic_number;
   m_enabled = enabled;
   m_mode = mode;
   m_trailing_distance = trailing_distance;
   m_trailing_step = trailing_step;
   m_atr_period = atr_period;
   m_atr_multiplier = atr_multiplier;

   //--- Initialize trade object
   m_trade.SetExpertMagicNumber(m_magic_number);
   m_trade.SetDeviationInPoints(10);

   return true;
  }

//+------------------------------------------------------------------+
//| Process trailing stops for all positions                         |
//+------------------------------------------------------------------+
void CTrailingStopManager::ProcessTrailingStops()
  {
   if(!m_enabled)
      return;

   //--- Get all positions for this symbol and magic number
   for(int i = PositionsTotal() - 1; i >= 0; i--)
     {
      if(!m_position_info.SelectByIndex(i))
         continue;

      //--- Check if position matches our criteria
      if(m_position_info.Symbol() != m_symbol ||
         m_position_info.Magic() != m_magic_number)
         continue;

      //--- Get position details
      ulong ticket = m_position_info.Ticket();
      double current_sl = m_position_info.StopLoss();
      double entry_price = m_position_info.PriceOpen();
      ENUM_POSITION_TYPE pos_type = m_position_info.PositionType();

      //--- Get current price
      double current_price = (pos_type == POSITION_TYPE_BUY) ?
                            SymbolInfoDouble(m_symbol, SYMBOL_BID) :
                            SymbolInfoDouble(m_symbol, SYMBOL_ASK);

      //--- Apply trailing stop
      ApplyTrailingStop(ticket, current_price, current_sl);
     }
  }

//+------------------------------------------------------------------+
//| Apply trailing stop to a specific position                      |
//+------------------------------------------------------------------+
bool CTrailingStopManager::ApplyTrailingStop(ulong ticket, double current_price, double current_sl)
  {
   if(!m_position_info.SelectByTicket(ticket))
      return false;

   ENUM_POSITION_TYPE pos_type = m_position_info.PositionType();
   double entry_price = m_position_info.PriceOpen();

   //--- Calculate new stop loss level
   double new_sl = CalculateTrailingLevel(entry_price, current_price, pos_type);

   if(new_sl == 0.0)
      return false;

   //--- Check if we need to move the stop loss
   bool should_move = false;

   if(pos_type == POSITION_TYPE_BUY)
     {
      // For buy positions, move SL up if new SL is higher than current SL
      if(new_sl > current_sl + m_trailing_step * _Point)
         should_move = true;
     }
   else // POSITION_TYPE_SELL
     {
      // For sell positions, move SL down if new SL is lower than current SL
      if(new_sl < current_sl - m_trailing_step * _Point)
         should_move = true;
     }

   if(!should_move)
      return false;

   //--- Normalize the stop loss price
   new_sl = NormalizeDouble(new_sl, _Digits);

   //--- Modify the position
   if(m_trade.PositionModify(ticket, new_sl, m_position_info.TakeProfit()))
     {
      Print("Trailing stop updated for position ", ticket, " to ", DoubleToString(new_sl, _Digits));
      return true;
     }
   else
     {
      Print("Failed to update trailing stop for position ", ticket, ": ", m_trade.ResultRetcodeDescription());
      return false;
     }
  }

//+------------------------------------------------------------------+
//| Calculate trailing stop level                                    |
//+------------------------------------------------------------------+
double CTrailingStopManager::CalculateTrailingLevel(double entry_price, double current_price, ENUM_POSITION_TYPE pos_type)
  {
   double trailing_level = 0.0;

   switch(m_mode)
     {
      case TRAILING_MODE_FIXED:
         {
            if(pos_type == POSITION_TYPE_BUY)
               trailing_level = current_price - m_trailing_distance * _Point;
            else // POSITION_TYPE_SELL
               trailing_level = current_price + m_trailing_distance * _Point;
            break;
         }

      case TRAILING_MODE_PERCENT:
         {
            double profit_points = MathAbs(current_price - entry_price) / _Point;
            double trailing_points = profit_points * m_trailing_distance / 100.0;

            if(pos_type == POSITION_TYPE_BUY)
               trailing_level = current_price - trailing_points * _Point;
            else // POSITION_TYPE_SELL
               trailing_level = current_price + trailing_points * _Point;
            break;
         }

      case TRAILING_MODE_ATR:
         {
            double atr_value = GetATRValue();
            if(atr_value == 0.0)
               return 0.0;

            double trailing_points = atr_value / _Point * m_atr_multiplier;

            if(pos_type == POSITION_TYPE_BUY)
               trailing_level = current_price - trailing_points * _Point;
            else // POSITION_TYPE_SELL
               trailing_level = current_price + trailing_points * _Point;
            break;
         }
     }

   return trailing_level;
  }

//+------------------------------------------------------------------+
//| Get ATR value for ATR-based trailing                             |
//+------------------------------------------------------------------+
double CTrailingStopManager::GetATRValue()
  {
   double atr_buffer[];
   ArraySetAsSeries(atr_buffer, true);

   int atr_handle = iATR(m_symbol, _Period, m_atr_period);
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
