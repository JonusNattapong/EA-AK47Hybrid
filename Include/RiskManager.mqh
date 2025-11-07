//+------------------------------------------------------------------+
//|                                                  RiskManager.mqh |
//|                        Copyright 2025, zombitx64 |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"

//+------------------------------------------------------------------+
//| Risk Manager Class                                               |
//+------------------------------------------------------------------+
class CRiskManager
  {
private:
   string            m_symbol;
   double            m_risk_percent;
   double            m_fixed_lot;
   bool              m_use_fixed_lot;
   double            m_max_lot;
   double            m_min_lot;

public:
                     CRiskManager();
                    ~CRiskManager();

   void              Init(string symbol, double risk_percent, double fixed_lot, bool use_fixed_lot);

   double            CalculateLotSize(double stop_loss_points);
   double            CalculateLotSizeByRisk(double stop_loss_points);
   double            GetAccountBalance();
   double            GetAccountEquity();
   double            GetAccountFreeMargin();
   bool              CheckMargin(double lot_size, ENUM_ORDER_TYPE order_type);
   double            NormalizeLot(double lot);

   void              SetRiskPercent(double risk_percent) { m_risk_percent = risk_percent; }
   void              SetFixedLot(double fixed_lot) { m_fixed_lot = fixed_lot; }
   void              SetUseFixedLot(bool use_fixed_lot) { m_use_fixed_lot = use_fixed_lot; }

   double            GetRiskPercent() { return m_risk_percent; }
   double            GetFixedLot() { return m_fixed_lot; }
   bool              GetUseFixedLot() { return m_use_fixed_lot; }
  };

//+------------------------------------------------------------------+
//| Constructor                                                       |
//+------------------------------------------------------------------+
CRiskManager::CRiskManager()
  {
   m_symbol = "";
   m_risk_percent = 1.0;
   m_fixed_lot = 0.01;
   m_use_fixed_lot = true;
   m_max_lot = 0;
   m_min_lot = 0;
  }

//+------------------------------------------------------------------+
//| Destructor                                                        |
//+------------------------------------------------------------------+
CRiskManager::~CRiskManager()
  {
  }

//+------------------------------------------------------------------+
//| Initialize risk manager                                           |
//+------------------------------------------------------------------+
void CRiskManager::Init(string symbol, double risk_percent, double fixed_lot, bool use_fixed_lot)
  {
   m_symbol = symbol;
   m_risk_percent = risk_percent;
   m_fixed_lot = fixed_lot;
   m_use_fixed_lot = use_fixed_lot;

   m_min_lot = SymbolInfoDouble(m_symbol, SYMBOL_VOLUME_MIN);
   m_max_lot = SymbolInfoDouble(m_symbol, SYMBOL_VOLUME_MAX);

   Print("Risk Manager initialized - Symbol: ", m_symbol,
         " | Risk: ", m_risk_percent, "%",
         " | Fixed Lot: ", m_fixed_lot,
         " | Use Fixed Lot: ", (m_use_fixed_lot ? "Yes" : "No"));
  }

//+------------------------------------------------------------------+
//| Calculate lot size                                                |
//+------------------------------------------------------------------+
double CRiskManager::CalculateLotSize(double stop_loss_points)
  {
   if(m_use_fixed_lot)
     {
      return NormalizeLot(m_fixed_lot);
     }
   else
     {
      return CalculateLotSizeByRisk(stop_loss_points);
     }
  }

//+------------------------------------------------------------------+
//| Calculate lot size by risk percentage                             |
//+------------------------------------------------------------------+
double CRiskManager::CalculateLotSizeByRisk(double stop_loss_points)
  {
   if(stop_loss_points <= 0)
     {
      Print("Invalid stop loss points, using fixed lot");
      return NormalizeLot(m_fixed_lot);
     }

   double account_balance = AccountInfoDouble(ACCOUNT_BALANCE);
   double risk_amount = account_balance * (m_risk_percent / 100.0);

   double point = SymbolInfoDouble(m_symbol, SYMBOL_POINT);
   double tick_size = SymbolInfoDouble(m_symbol, SYMBOL_TRADE_TICK_SIZE);
   double tick_value = SymbolInfoDouble(m_symbol, SYMBOL_TRADE_TICK_VALUE);

   if(tick_size == 0 || point == 0)
     {
      Print("Error: Invalid tick size or point value");
      return NormalizeLot(m_fixed_lot);
     }

   // Calculate lot size based on risk
   double stop_loss_price = stop_loss_points * point;
   double lots = risk_amount / (stop_loss_price / tick_size * tick_value);

   return NormalizeLot(lots);
  }

//+------------------------------------------------------------------+
//| Get account balance                                               |
//+------------------------------------------------------------------+
double CRiskManager::GetAccountBalance()
  {
   return AccountInfoDouble(ACCOUNT_BALANCE);
  }

//+------------------------------------------------------------------+
//| Get account equity                                                |
//+------------------------------------------------------------------+
double CRiskManager::GetAccountEquity()
  {
   return AccountInfoDouble(ACCOUNT_EQUITY);
  }

//+------------------------------------------------------------------+
//| Get account free margin                                           |
//+------------------------------------------------------------------+
double CRiskManager::GetAccountFreeMargin()
  {
   return AccountInfoDouble(ACCOUNT_MARGIN_FREE);
  }

//+------------------------------------------------------------------+
//| Check if there is enough margin                                   |
//+------------------------------------------------------------------+
bool CRiskManager::CheckMargin(double lot_size, ENUM_ORDER_TYPE order_type)
  {
   double free_margin = GetAccountFreeMargin();
   double required_margin = 0;

   if(!OrderCalcMargin(order_type, m_symbol, lot_size,
                       SymbolInfoDouble(m_symbol, SYMBOL_ASK), required_margin))
     {
      Print("Error calculating required margin");
      return false;
     }

   if(required_margin > free_margin)
     {
      Print("Not enough margin. Required: ", required_margin, " | Available: ", free_margin);
      return false;
     }

   return true;
  }

//+------------------------------------------------------------------+
//| Normalize lot size                                                |
//+------------------------------------------------------------------+
double CRiskManager::NormalizeLot(double lot)
  {
   double lot_step = SymbolInfoDouble(m_symbol, SYMBOL_VOLUME_STEP);

   if(lot < m_min_lot)
      lot = m_min_lot;

   if(lot > m_max_lot)
      lot = m_max_lot;

   lot = MathFloor(lot / lot_step) * lot_step;

   return NormalizeDouble(lot, 2);
  }
//+------------------------------------------------------------------+
