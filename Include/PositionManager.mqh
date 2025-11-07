//+------------------------------------------------------------------+
//|                                           PositionManager.mqh |
//|                        Copyright 2023, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"

//--- Include necessary libraries
#include <Trade\PositionInfo.mqh>
#include <Trade\Trade.mqh>

//--- Structs
struct STakeProfitLevel
  {
   double            profit_points;     // Profit in points to trigger TP
   double            volume_percent;    // Percentage of position to close (0.0 - 1.0)
   bool              enabled;           // Enable/disable this TP level
  };

//+------------------------------------------------------------------+
//| Class CPositionManager                                            |
//| Purpose: Advanced position management with partial closes, etc.  |
//+------------------------------------------------------------------+
class CPositionManager
  {
private:
   CPositionInfo      m_position_info;
   CTrade             m_trade;

   string             m_symbol;
   int                m_magic_number;
   bool               m_enabled;

   //--- Partial close settings
   bool               m_partial_close_enabled;
   double             m_partial_close_trigger;    // Profit in points to trigger partial close
   double             m_partial_close_percent;    // Percentage to close (0.1 - 0.9)

   //--- Multiple take profit levels
   STakeProfitLevel   m_tp_levels[3];            // Up to 3 TP levels
   bool               m_multiple_tp_enabled;

   //--- Internal methods
   bool               ProcessPartialClose(ulong ticket);
   bool               ProcessMultipleTakeProfits(ulong ticket);
   double             CalculatePositionProfit(ulong ticket);

public:
   //--- Constructor/Destructor
                     CPositionManager();
                    ~CPositionManager();

   //--- Initialization
   bool               Init(string symbol, int magic_number, bool enabled = true);

   //--- Main methods
   void               ProcessPositions();
   bool               IsEnabled() { return m_enabled; }

   //--- Partial close methods
   void               SetPartialClose(bool enabled, double trigger_points, double close_percent);
   bool               GetPartialClose(bool &enabled, double &trigger_points, double &close_percent);

   //--- Multiple TP methods
   void               SetTakeProfitLevel(int level, double profit_points, double volume_percent, bool enabled);
   bool               GetTakeProfitLevel(int level, double &profit_points, double &volume_percent, bool &enabled);
   void               SetMultipleTPEnabled(bool enabled) { m_multiple_tp_enabled = enabled; }
   bool               IsMultipleTPEnabled() { return m_multiple_tp_enabled; }

   //--- Setters
   void               SetEnabled(bool enabled) { m_enabled = enabled; }
  };

//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CPositionManager::CPositionManager()
  {
   m_symbol = "";
   m_magic_number = 0;
   m_enabled = false;
   m_partial_close_enabled = false;
   m_partial_close_trigger = 50.0;
   m_partial_close_percent = 0.5;
   m_multiple_tp_enabled = false;

   //--- Initialize TP levels
   for(int i = 0; i < 3; i++)
     {
      m_tp_levels[i].profit_points = (i + 1) * 25.0;  // 25, 50, 75 points
      m_tp_levels[i].volume_percent = 0.33;           // 33% each
      m_tp_levels[i].enabled = false;
     }
  }

//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CPositionManager::~CPositionManager()
  {
  }

//+------------------------------------------------------------------+
//| Initialize the position manager                                  |
//+------------------------------------------------------------------+
bool CPositionManager::Init(string symbol, int magic_number, bool enabled = true)
  {
   m_symbol = symbol;
   m_magic_number = magic_number;
   m_enabled = enabled;

   //--- Initialize trade object
   m_trade.SetExpertMagicNumber(m_magic_number);
   m_trade.SetDeviationInPoints(10);

   return true;
  }

//+------------------------------------------------------------------+
//| Process all positions for advanced management                    |
//+------------------------------------------------------------------+
void CPositionManager::ProcessPositions()
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

      ulong ticket = m_position_info.Ticket();

      //--- Process partial close
      if(m_partial_close_enabled)
         ProcessPartialClose(ticket);

      //--- Process multiple take profits
      if(m_multiple_tp_enabled)
         ProcessMultipleTakeProfits(ticket);
     }
  }

//+------------------------------------------------------------------+
//| Process partial close for a position                             |
//+------------------------------------------------------------------+
bool CPositionManager::ProcessPartialClose(ulong ticket)
  {
   if(!m_position_info.SelectByTicket(ticket))
      return false;

   double profit_points = CalculatePositionProfit(ticket);

   //--- Check if partial close should be triggered
   if(profit_points >= m_partial_close_trigger)
     {
      double current_volume = m_position_info.Volume();
      double close_volume = current_volume * m_partial_close_percent;

      //--- Ensure minimum volume
      double min_volume = SymbolInfoDouble(m_symbol, SYMBOL_VOLUME_MIN);
      if(close_volume < min_volume)
         close_volume = min_volume;

      //--- Close partial position
      if(m_trade.PositionClosePartial(ticket, close_volume))
        {
         Print("Partial close executed for position ", ticket,
               " (Closed ", DoubleToString(close_volume, 2), " lots at ", DoubleToString(profit_points, 1), " points profit)");
         return true;
        }
      else
        {
         Print("Failed to execute partial close for position ", ticket, ": ", m_trade.ResultRetcodeDescription());
         return false;
        }
     }

   return false;
  }

//+------------------------------------------------------------------+
//| Process multiple take profit levels                              |
//+------------------------------------------------------------------+
bool CPositionManager::ProcessMultipleTakeProfits(ulong ticket)
  {
   if(!m_position_info.SelectByTicket(ticket))
      return false;

   double profit_points = CalculatePositionProfit(ticket);
   bool action_taken = false;

   //--- Check each TP level
   for(int i = 0; i < 3; i++)
     {
      if(!m_tp_levels[i].enabled)
         continue;

      if(profit_points >= m_tp_levels[i].profit_points)
        {
         double current_volume = m_position_info.Volume();
         double close_volume = current_volume * m_tp_levels[i].volume_percent;

         //--- Ensure minimum volume
         double min_volume = SymbolInfoDouble(m_symbol, SYMBOL_VOLUME_MIN);
         if(close_volume < min_volume)
            close_volume = min_volume;

         //--- Close partial position at this TP level
         if(m_trade.PositionClosePartial(ticket, close_volume))
           {
            Print("TP Level ", (i + 1), " executed for position ", ticket,
                  " (Closed ", DoubleToString(close_volume, 2), " lots at ", DoubleToString(profit_points, 1), " points profit)");
            action_taken = true;

            //--- Disable this TP level after execution
            m_tp_levels[i].enabled = false;
           }
         else
           {
            Print("Failed to execute TP Level ", (i + 1), " for position ", ticket, ": ", m_trade.ResultRetcodeDescription());
           }
        }
     }

   return action_taken;
  }

//+------------------------------------------------------------------+
//| Calculate current profit in points for a position               |
//+------------------------------------------------------------------+
double CPositionManager::CalculatePositionProfit(ulong ticket)
  {
   if(!m_position_info.SelectByTicket(ticket))
      return 0.0;

   double entry_price = m_position_info.PriceOpen();
   double current_price = (m_position_info.PositionType() == POSITION_TYPE_BUY) ?
                         SymbolInfoDouble(m_symbol, SYMBOL_BID) :
                         SymbolInfoDouble(m_symbol, SYMBOL_ASK);

   double profit_points = 0.0;
   if(m_position_info.PositionType() == POSITION_TYPE_BUY)
      profit_points = (current_price - entry_price) / _Point;
   else // POSITION_TYPE_SELL
      profit_points = (entry_price - current_price) / _Point;

   return profit_points;
  }

//+------------------------------------------------------------------+
//| Set partial close settings                                       |
//+------------------------------------------------------------------+
void CPositionManager::SetPartialClose(bool enabled, double trigger_points, double close_percent)
  {
   m_partial_close_enabled = enabled;
   m_partial_close_trigger = trigger_points;
   m_partial_close_percent = MathMax(0.1, MathMin(0.9, close_percent));  // Clamp between 10% and 90%
  }

//+------------------------------------------------------------------+
//| Get partial close settings                                       |
//+------------------------------------------------------------------+
bool CPositionManager::GetPartialClose(bool &enabled, double &trigger_points, double &close_percent)
  {
   enabled = m_partial_close_enabled;
   trigger_points = m_partial_close_trigger;
   close_percent = m_partial_close_percent;
   return true;
  }

//+------------------------------------------------------------------+
//| Set take profit level                                            |
//+------------------------------------------------------------------+
void CPositionManager::SetTakeProfitLevel(int level, double profit_points, double volume_percent, bool enabled)
  {
   if(level >= 0 && level < 3)
     {
      m_tp_levels[level].profit_points = profit_points;
      m_tp_levels[level].volume_percent = MathMax(0.1, MathMin(1.0, volume_percent));  // Clamp between 10% and 100%
      m_tp_levels[level].enabled = enabled;
     }
  }

//+------------------------------------------------------------------+
//| Get take profit level                                            |
//+------------------------------------------------------------------+
bool CPositionManager::GetTakeProfitLevel(int level, double &profit_points, double &volume_percent, bool &enabled)
  {
   if(level >= 0 && level < 3)
     {
      profit_points = m_tp_levels[level].profit_points;
      volume_percent = m_tp_levels[level].volume_percent;
      enabled = m_tp_levels[level].enabled;
      return true;
     }
   return false;
  }
//+------------------------------------------------------------------+
