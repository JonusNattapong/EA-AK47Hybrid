//+------------------------------------------------------------------+
//|                                           BreakevenManager.mqh |
//|                        Copyright 2025, zombitx64 |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"

//--- Include necessary libraries
#include <Trade\PositionInfo.mqh>
#include <Trade\Trade.mqh>

//+------------------------------------------------------------------+
//| Class CBreakevenManager                                          |
//| Purpose: Manages automatic breakeven moves                      |
//+------------------------------------------------------------------+
class CBreakevenManager
  {
private:
   CPositionInfo      m_position_info;
   CTrade             m_trade;

   string             m_symbol;
   int                m_magic_number;
   bool               m_enabled;
   double             m_breakeven_trigger;    // Profit in points to trigger breakeven
   double             m_breakeven_offset;     // Offset from entry price (points)
   bool               m_partial_breakeven;    // Move SL to breakeven + offset

public:
   //--- Constructor/Destructor
                     CBreakevenManager();
                    ~CBreakevenManager();

   //--- Initialization
   bool               Init(string symbol, int magic_number, bool enabled = true,
                          double breakeven_trigger = 20.0, double breakeven_offset = 2.0,
                          bool partial_breakeven = false);

   //--- Main methods
   void               ProcessBreakeven();
   bool               IsEnabled() { return m_enabled; }

   //--- Setters
   void               SetEnabled(bool enabled) { m_enabled = enabled; }
   void               SetBreakevenTrigger(double trigger) { m_breakeven_trigger = trigger; }
   void               SetBreakevenOffset(double offset) { m_breakeven_offset = offset; }
   void               SetPartialBreakeven(bool partial) { m_partial_breakeven = partial; }
  };

//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CBreakevenManager::CBreakevenManager()
  {
   m_symbol = "";
   m_magic_number = 0;
   m_enabled = false;
   m_breakeven_trigger = 20.0;
   m_breakeven_offset = 2.0;
   m_partial_breakeven = false;
  }

//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CBreakevenManager::~CBreakevenManager()
  {
  }

//+------------------------------------------------------------------+
//| Initialize the breakeven manager                                 |
//+------------------------------------------------------------------+
bool CBreakevenManager::Init(string symbol, int magic_number, bool enabled = true,
                            double breakeven_trigger = 20.0, double breakeven_offset = 2.0,
                            bool partial_breakeven = false)
  {
   m_symbol = symbol;
   m_magic_number = magic_number;
   m_enabled = enabled;
   m_breakeven_trigger = breakeven_trigger;
   m_breakeven_offset = breakeven_offset;
   m_partial_breakeven = partial_breakeven;

   //--- Initialize trade object
   m_trade.SetExpertMagicNumber(m_magic_number);
   m_trade.SetDeviationInPoints(10);

   return true;
  }

//+------------------------------------------------------------------+
//| Process breakeven for all positions                              |
//+------------------------------------------------------------------+
void CBreakevenManager::ProcessBreakeven()
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

      //--- Skip if already at breakeven or better
      if(pos_type == POSITION_TYPE_BUY && current_sl >= entry_price)
         continue;
      if(pos_type == POSITION_TYPE_SELL && current_sl <= entry_price && current_sl > 0)
         continue;

      //--- Get current price
      double current_price = (pos_type == POSITION_TYPE_BUY) ?
                            SymbolInfoDouble(m_symbol, SYMBOL_BID) :
                            SymbolInfoDouble(m_symbol, SYMBOL_ASK);

      //--- Calculate current profit in points
      double profit_points = 0.0;
      if(pos_type == POSITION_TYPE_BUY)
         profit_points = (current_price - entry_price) / _Point;
      else // POSITION_TYPE_SELL
         profit_points = (entry_price - current_price) / _Point;

      //--- Check if breakeven should be triggered
      if(profit_points >= m_breakeven_trigger)
        {
         double new_sl = 0.0;

         if(m_partial_breakeven)
           {
            // Move SL to breakeven + offset
            if(pos_type == POSITION_TYPE_BUY)
               new_sl = entry_price + m_breakeven_offset * _Point;
            else // POSITION_TYPE_SELL
               new_sl = entry_price - m_breakeven_offset * _Point;
           }
         else
           {
            // Move SL to breakeven (entry price)
            new_sl = entry_price;
           }

         //--- Normalize the stop loss price
         new_sl = NormalizeDouble(new_sl, _Digits);

         //--- Modify the position
         if(m_trade.PositionModify(ticket, new_sl, m_position_info.TakeProfit()))
           {
            Print("Breakeven applied for position ", ticket, " to ", DoubleToString(new_sl, _Digits),
                  " (Profit: ", DoubleToString(profit_points, 1), " points)");
           }
         else
           {
            Print("Failed to apply breakeven for position ", ticket, ": ", m_trade.ResultRetcodeDescription());
           }
        }
     }
  }
//+------------------------------------------------------------------+
