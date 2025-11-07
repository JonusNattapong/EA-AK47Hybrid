//+------------------------------------------------------------------+
//|                                             TradeManager.mqh |
//|                        Copyright 2025, zombitx64 |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"

#include <Trade\Trade.mqh>

//+------------------------------------------------------------------+
//| Trade Manager Class                                              |
//+------------------------------------------------------------------+
class CTradeManager
  {
private:
   CTrade            m_trade;
   string            m_symbol;
   ulong             m_magic_number;
   double            m_lot_size;
   int               m_stop_loss;
   int               m_take_profit;
   int               m_deviation;

public:
                     CTradeManager();
                    ~CTradeManager();

   void              Init(string symbol, ulong magic_number, double lot_size, int stop_loss, int take_profit, int deviation = 10);
   void              SetLot(double lot_size);

   bool              OpenBuy(double price);
   bool              OpenSell(double price);
   bool              ClosePosition(ulong ticket);
   bool              CloseAllPositions();

   bool              HasBuyPosition();
   bool              HasSellPosition();
   int               CountPositions();

   double            NormalizePrice(double price);
   double            NormalizeLots(double lots);
  };

//+------------------------------------------------------------------+
//| Constructor                                                       |
//+------------------------------------------------------------------+
CTradeManager::CTradeManager()
  {
   m_symbol = "";
   m_magic_number = 0;
   m_lot_size = 0.01;
   m_stop_loss = 0;
   m_take_profit = 0;
   m_deviation = 10;
  }

//+------------------------------------------------------------------+
//| Destructor                                                        |
//+------------------------------------------------------------------+
CTradeManager::~CTradeManager()
  {
  }

//+------------------------------------------------------------------+
//| Initialize trade manager                                          |
//+------------------------------------------------------------------+
void CTradeManager::Init(string symbol, ulong magic_number, double lot_size, int stop_loss, int take_profit, int deviation = 10)
  {
   m_symbol = symbol;
   m_magic_number = magic_number;
   m_lot_size = lot_size;
   m_stop_loss = stop_loss;
   m_take_profit = take_profit;
   m_deviation = deviation;

   m_trade.SetExpertMagicNumber(m_magic_number);
   m_trade.SetDeviationInPoints(m_deviation);
   m_trade.SetTypeFilling(ORDER_FILLING_FOK);

   Print("Trade Manager initialized for ", m_symbol, " with Magic Number: ", m_magic_number);
  }

//+------------------------------------------------------------------+
//| Set lot size                                                     |
//+------------------------------------------------------------------+
void CTradeManager::SetLot(double lot_size)
  {
   m_lot_size = lot_size;
  }

//+------------------------------------------------------------------+
//| Normalize price                                                   |
//+------------------------------------------------------------------+
double CTradeManager::NormalizePrice(double price)
  {
   return NormalizeDouble(price, (int)SymbolInfoInteger(m_symbol, SYMBOL_DIGITS));
  }

//+------------------------------------------------------------------+
//| Normalize lots                                                    |
//+------------------------------------------------------------------+
double CTradeManager::NormalizeLots(double lots)
  {
   double min_lot = SymbolInfoDouble(m_symbol, SYMBOL_VOLUME_MIN);
   double max_lot = SymbolInfoDouble(m_symbol, SYMBOL_VOLUME_MAX);
   double lot_step = SymbolInfoDouble(m_symbol, SYMBOL_VOLUME_STEP);

   if(lots < min_lot)
      lots = min_lot;
   if(lots > max_lot)
      lots = max_lot;

   lots = MathFloor(lots / lot_step) * lot_step;

   return NormalizeDouble(lots, 2);
  }

//+------------------------------------------------------------------+
//| Open Buy Position                                                 |
//+------------------------------------------------------------------+
bool CTradeManager::OpenBuy(double price)
  {
   double ask = SymbolInfoDouble(m_symbol, SYMBOL_ASK);
   double point = SymbolInfoDouble(m_symbol, SYMBOL_POINT);

   double sl = (m_stop_loss > 0) ? NormalizePrice(ask - m_stop_loss * point) : 0;
   double tp = (m_take_profit > 0) ? NormalizePrice(ask + m_take_profit * point) : 0;
   double lots = NormalizeLots(m_lot_size);

   bool result = m_trade.Buy(lots, m_symbol, ask, sl, tp, "EA-AK47Hybrid Buy");

   if(result)
     {
      Print("Buy position opened successfully at ", ask, " | SL: ", sl, " | TP: ", tp);
      return true;
     }
   else
     {
      Print("Error opening buy position: ", GetLastError(), " | ", m_trade.ResultRetcodeDescription());
      return false;
     }
  }

//+------------------------------------------------------------------+
//| Open Sell Position                                                |
//+------------------------------------------------------------------+
bool CTradeManager::OpenSell(double price)
  {
   double bid = SymbolInfoDouble(m_symbol, SYMBOL_BID);
   double point = SymbolInfoDouble(m_symbol, SYMBOL_POINT);

   double sl = (m_stop_loss > 0) ? NormalizePrice(bid + m_stop_loss * point) : 0;
   double tp = (m_take_profit > 0) ? NormalizePrice(bid - m_take_profit * point) : 0;
   double lots = NormalizeLots(m_lot_size);

   bool result = m_trade.Sell(lots, m_symbol, bid, sl, tp, "EA-AK47Hybrid Sell");

   if(result)
     {
      Print("Sell position opened successfully at ", bid, " | SL: ", sl, " | TP: ", tp);
      return true;
     }
   else
     {
      Print("Error opening sell position: ", GetLastError(), " | ", m_trade.ResultRetcodeDescription());
      return false;
     }
  }

//+------------------------------------------------------------------+
//| Close Position                                                    |
//+------------------------------------------------------------------+
bool CTradeManager::ClosePosition(ulong ticket)
  {
   bool result = m_trade.PositionClose(ticket);

   if(result)
     {
      Print("Position ", ticket, " closed successfully");
      return true;
     }
   else
     {
      Print("Error closing position ", ticket, ": ", GetLastError());
      return false;
     }
  }

//+------------------------------------------------------------------+
//| Close All Positions                                               |
//+------------------------------------------------------------------+
bool CTradeManager::CloseAllPositions()
  {
   int total = PositionsTotal();
   bool all_closed = true;

   for(int i = total - 1; i >= 0; i--)
     {
      ulong ticket = PositionGetTicket(i);
      if(PositionSelectByTicket(ticket))
        {
         if(PositionGetString(POSITION_SYMBOL) == m_symbol &&
            PositionGetInteger(POSITION_MAGIC) == m_magic_number)
           {
            if(!ClosePosition(ticket))
               all_closed = false;
           }
        }
     }

   return all_closed;
  }

//+------------------------------------------------------------------+
//| Check if has buy position                                         |
//+------------------------------------------------------------------+
bool CTradeManager::HasBuyPosition()
  {
   int total = PositionsTotal();

   for(int i = 0; i < total; i++)
     {
      ulong ticket = PositionGetTicket(i);
      if(PositionSelectByTicket(ticket))
        {
         if(PositionGetString(POSITION_SYMBOL) == m_symbol &&
            PositionGetInteger(POSITION_MAGIC) == m_magic_number &&
            PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY)
           {
            return true;
           }
        }
     }

   return false;
  }

//+------------------------------------------------------------------+
//| Check if has sell position                                        |
//+------------------------------------------------------------------+
bool CTradeManager::HasSellPosition()
  {
   int total = PositionsTotal();

   for(int i = 0; i < total; i++)
     {
      ulong ticket = PositionGetTicket(i);
      if(PositionSelectByTicket(ticket))
        {
         if(PositionGetString(POSITION_SYMBOL) == m_symbol &&
            PositionGetInteger(POSITION_MAGIC) == m_magic_number &&
            PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL)
           {
            return true;
           }
        }
     }

   return false;
  }

//+------------------------------------------------------------------+
//| Count positions                                                   |
//+------------------------------------------------------------------+
int CTradeManager::CountPositions()
  {
   int count = 0;
   int total = PositionsTotal();

   for(int i = 0; i < total; i++)
     {
      ulong ticket = PositionGetTicket(i);
      if(PositionSelectByTicket(ticket))
        {
         if(PositionGetString(POSITION_SYMBOL) == m_symbol &&
            PositionGetInteger(POSITION_MAGIC) == m_magic_number)
           {
            count++;
           }
        }
     }

   return count;
  }
//+------------------------------------------------------------------+
