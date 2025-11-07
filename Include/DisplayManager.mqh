//+------------------------------------------------------------------+
//|                                                DisplayManager.mqh |
//|                        Copyright 2023, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"

//--- Include necessary libraries
#include <Trade\PositionInfo.mqh>
#include <Trade\Trade.mqh>

//--- Forward declarations for manager classes
class CSignalManager;
class CGoldOptimizer;

//+------------------------------------------------------------------+
//| Class CDisplayManager                                             |
//| Purpose: Manages comprehensive chart overlay with EA information |
//+------------------------------------------------------------------+
class CDisplayManager
  {
private:
   string             m_symbol;
   bool               m_enabled;
   color              m_text_color;
   int                m_font_size;
   string             m_font_name;

   //--- Chart object names
   string             m_panel_name;
   string             m_title_name;
   string             m_status_name;
   string             m_positions_name;
   string             m_signals_name;
   string             m_account_name;
   string             m_parameters_name;
   string             m_optimizer_name;

   //--- Position info
   CPositionInfo      m_position_info;

   //--- References to other managers
   CSignalManager     *m_signal_manager;
   CGoldOptimizer     *m_gold_optimizer;

   //--- Internal methods
   void               DrawPanel();
   void               UpdateTitle();
   void               UpdateStatus();
   void               UpdatePositions();
   void               UpdateSignals();
   void               UpdateAccount();
   void               UpdateParameters();
   void               UpdateOptimizer();
   string             GetSignalStatus();
   string             GetPositionSummary();
   string             GetAccountSummary();
   string             GetParameterSummary();
   string             GetOptimizerSummary();

public:
   //--- Constructor/Destructor
                     CDisplayManager();
                    ~CDisplayManager();

   //--- Initialization
   bool               Init(string symbol, bool enabled = true,
                          color text_color = clrWhite, int font_size = 8,
                          string font_name = "Arial", CSignalManager *signal_manager = NULL,
                          CGoldOptimizer *gold_optimizer = NULL);

   //--- Main methods
   void               UpdateDisplay();
   bool               IsEnabled() { return m_enabled; }
   void               Show();
   void               Hide();

   //--- Setters
   void               SetEnabled(bool enabled) { m_enabled = enabled; }
   void               SetTextColor(color clr) { m_text_color = clr; }
   void               SetFontSize(int size) { m_font_size = size; }
   void               SetFontName(string name) { m_font_name = name; }
  };

//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CDisplayManager::CDisplayManager()
  {
   m_symbol = "";
   m_enabled = false;
   m_text_color = clrWhite;
   m_font_size = 8;
   m_font_name = "Arial";

   m_panel_name = "EA_Display_Panel";
   m_title_name = "EA_Display_Title";
   m_status_name = "EA_Display_Status";
   m_positions_name = "EA_Display_Positions";
   m_signals_name = "EA_Display_Signals";
   m_account_name = "EA_Display_Account";
   m_parameters_name = "EA_Display_Parameters";
   m_optimizer_name = "EA_Display_Optimizer";

   m_signal_manager = NULL;
   m_gold_optimizer = NULL;
  }

//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CDisplayManager::~CDisplayManager()
  {
   Hide();
  }

//+------------------------------------------------------------------+
//| Initialize the display manager                                   |
//+------------------------------------------------------------------+
bool CDisplayManager::Init(string symbol, bool enabled = true,
                          color text_color = clrWhite, int font_size = 8,
                          string font_name = "Arial", CSignalManager *signal_manager = NULL,
                          CGoldOptimizer *gold_optimizer = NULL)
  {
   m_symbol = symbol;
   m_enabled = enabled;
   m_text_color = text_color;
   m_font_size = font_size;
   m_font_name = font_name;
   m_signal_manager = signal_manager;
   m_gold_optimizer = gold_optimizer;

   if(m_enabled)
      Show();

   return true;
  }

//+------------------------------------------------------------------+
//| Update all display elements                                      |
//+------------------------------------------------------------------+
void CDisplayManager::UpdateDisplay()
  {
   if(!m_enabled)
      return;

   UpdateTitle();
   UpdateStatus();
   UpdatePositions();
   UpdateSignals();
   UpdateAccount();
   UpdateParameters();
   UpdateOptimizer();
  }

//+------------------------------------------------------------------+
//| Show the display panel                                           |
//+------------------------------------------------------------------+
void CDisplayManager::Show()
  {
   if(!m_enabled)
      return;

   DrawPanel();
   UpdateDisplay();
  }

//+------------------------------------------------------------------+
//| Hide the display panel                                           |
//+------------------------------------------------------------------+
void CDisplayManager::Hide()
  {
   ObjectDelete(0, m_panel_name);
   ObjectDelete(0, m_title_name);
   ObjectDelete(0, m_status_name);
   ObjectDelete(0, m_positions_name);
   ObjectDelete(0, m_signals_name);
   ObjectDelete(0, m_account_name);
   ObjectDelete(0, m_parameters_name);
   ObjectDelete(0, m_optimizer_name);
  }

//+------------------------------------------------------------------+
//| Draw the main display panel                                      |
//+------------------------------------------------------------------+
void CDisplayManager::DrawPanel()
  {
   //--- Create background rectangle
   if(ObjectFind(0, m_panel_name) < 0)
     {
      ObjectCreate(0, m_panel_name, OBJ_RECTANGLE_LABEL, 0, 0, 0);
      ObjectSetInteger(0, m_panel_name, OBJPROP_XDISTANCE, 10);
      ObjectSetInteger(0, m_panel_name, OBJPROP_YDISTANCE, 20);
      ObjectSetInteger(0, m_panel_name, OBJPROP_XSIZE, 300);
      ObjectSetInteger(0, m_panel_name, OBJPROP_YSIZE, 400);
      ObjectSetInteger(0, m_panel_name, OBJPROP_BGCOLOR, clrBlack);
      ObjectSetInteger(0, m_panel_name, OBJPROP_BORDER_COLOR, clrGray);
      ObjectSetInteger(0, m_panel_name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
      ObjectSetInteger(0, m_panel_name, OBJPROP_STYLE, STYLE_SOLID);
      ObjectSetInteger(0, m_panel_name, OBJPROP_WIDTH, 1);
     }
  }

//+------------------------------------------------------------------+
//| Update the title                                                 |
//+------------------------------------------------------------------+
void CDisplayManager::UpdateTitle()
  {
   string title = "EA-AK47Hybrid v1.10 - Gold Trading 2025";

   if(ObjectFind(0, m_title_name) < 0)
     {
      ObjectCreate(0, m_title_name, OBJ_LABEL, 0, 0, 0);
      ObjectSetInteger(0, m_title_name, OBJPROP_XDISTANCE, 20);
      ObjectSetInteger(0, m_title_name, OBJPROP_YDISTANCE, 30);
      ObjectSetInteger(0, m_title_name, OBJPROP_COLOR, clrGold);
      ObjectSetInteger(0, m_title_name, OBJPROP_FONTSIZE, m_font_size + 2);
      ObjectSetString(0, m_title_name, OBJPROP_FONT, m_font_name);
      ObjectSetInteger(0, m_title_name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
     }

   ObjectSetString(0, m_title_name, OBJPROP_TEXT, title);
  }

//+------------------------------------------------------------------+
//| Update the status information                                    |
//+------------------------------------------------------------------+
void CDisplayManager::UpdateStatus()
  {
   string status = "Status: Active\n";
   status += "Symbol: " + m_symbol + "\n";
   status += "Timeframe: " + EnumToString(_Period) + "\n";
   status += "Server Time: " + TimeToString(TimeTradeServer(), TIME_MINUTES);

   if(ObjectFind(0, m_status_name) < 0)
     {
      ObjectCreate(0, m_status_name, OBJ_LABEL, 0, 0, 0);
      ObjectSetInteger(0, m_status_name, OBJPROP_XDISTANCE, 20);
      ObjectSetInteger(0, m_status_name, OBJPROP_YDISTANCE, 60);
      ObjectSetInteger(0, m_status_name, OBJPROP_COLOR, m_text_color);
      ObjectSetInteger(0, m_status_name, OBJPROP_FONTSIZE, m_font_size);
      ObjectSetString(0, m_status_name, OBJPROP_FONT, m_font_name);
      ObjectSetInteger(0, m_status_name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
     }

   ObjectSetString(0, m_status_name, OBJPROP_TEXT, status);
  }

//+------------------------------------------------------------------+
//| Update positions information                                     |
//+------------------------------------------------------------------+
void CDisplayManager::UpdatePositions()
  {
   string positions = "Positions:\n" + GetPositionSummary();

   if(ObjectFind(0, m_positions_name) < 0)
     {
      ObjectCreate(0, m_positions_name, OBJ_LABEL, 0, 0, 0);
      ObjectSetInteger(0, m_positions_name, OBJPROP_XDISTANCE, 20);
      ObjectSetInteger(0, m_positions_name, OBJPROP_YDISTANCE, 120);
      ObjectSetInteger(0, m_positions_name, OBJPROP_COLOR, m_text_color);
      ObjectSetInteger(0, m_positions_name, OBJPROP_FONTSIZE, m_font_size);
      ObjectSetString(0, m_positions_name, OBJPROP_FONT, m_font_name);
      ObjectSetInteger(0, m_positions_name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
     }

   ObjectSetString(0, m_positions_name, OBJPROP_TEXT, positions);
  }

//+------------------------------------------------------------------+
//| Update signals information                                       |
//+------------------------------------------------------------------+
void CDisplayManager::UpdateSignals()
  {
   string signals = "Signals:\n" + GetSignalStatus();

   if(ObjectFind(0, m_signals_name) < 0)
     {
      ObjectCreate(0, m_signals_name, OBJ_LABEL, 0, 0, 0);
      ObjectSetInteger(0, m_signals_name, OBJPROP_XDISTANCE, 20);
      ObjectSetInteger(0, m_signals_name, OBJPROP_YDISTANCE, 180);
      ObjectSetInteger(0, m_signals_name, OBJPROP_COLOR, m_text_color);
      ObjectSetInteger(0, m_signals_name, OBJPROP_FONTSIZE, m_font_size);
      ObjectSetString(0, m_signals_name, OBJPROP_FONT, m_font_name);
      ObjectSetInteger(0, m_signals_name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
     }

   ObjectSetString(0, m_signals_name, OBJPROP_TEXT, signals);
  }

//+------------------------------------------------------------------+
//| Update account information                                       |
//+------------------------------------------------------------------+
void CDisplayManager::UpdateAccount()
  {
   string account = "Account:\n" + GetAccountSummary();

   if(ObjectFind(0, m_account_name) < 0)
     {
      ObjectCreate(0, m_account_name, OBJ_LABEL, 0, 0, 0);
      ObjectSetInteger(0, m_account_name, OBJPROP_XDISTANCE, 20);
      ObjectSetInteger(0, m_account_name, OBJPROP_YDISTANCE, 240);
      ObjectSetInteger(0, m_account_name, OBJPROP_COLOR, m_text_color);
      ObjectSetInteger(0, m_account_name, OBJPROP_FONTSIZE, m_font_size);
      ObjectSetString(0, m_account_name, OBJPROP_FONT, m_font_name);
      ObjectSetInteger(0, m_account_name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
     }

   ObjectSetString(0, m_account_name, OBJPROP_TEXT, account);
  }

//+------------------------------------------------------------------+
//| Update parameters information                                    |
//+------------------------------------------------------------------+
void CDisplayManager::UpdateParameters()
  {
   string parameters = "Parameters:\n" + GetParameterSummary();

   if(ObjectFind(0, m_parameters_name) < 0)
     {
      ObjectCreate(0, m_parameters_name, OBJ_LABEL, 0, 0, 0);
      ObjectSetInteger(0, m_parameters_name, OBJPROP_XDISTANCE, 20);
      ObjectSetInteger(0, m_parameters_name, OBJPROP_YDISTANCE, 300);
      ObjectSetInteger(0, m_parameters_name, OBJPROP_COLOR, m_text_color);
      ObjectSetInteger(0, m_parameters_name, OBJPROP_FONTSIZE, m_font_size);
      ObjectSetString(0, m_parameters_name, OBJPROP_FONT, m_font_name);
      ObjectSetInteger(0, m_parameters_name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
     }

   ObjectSetString(0, m_parameters_name, OBJPROP_TEXT, parameters);
  }

//+------------------------------------------------------------------+
//| Update optimizer information                                     |
//+------------------------------------------------------------------+
void CDisplayManager::UpdateOptimizer()
  {
   string optimizer = "Optimizer:\n" + GetOptimizerSummary();

   if(ObjectFind(0, m_optimizer_name) < 0)
     {
      ObjectCreate(0, m_optimizer_name, OBJ_LABEL, 0, 0, 0);
      ObjectSetInteger(0, m_optimizer_name, OBJPROP_XDISTANCE, 20);
      ObjectSetInteger(0, m_optimizer_name, OBJPROP_YDISTANCE, 360);
      ObjectSetInteger(0, m_optimizer_name, OBJPROP_COLOR, m_text_color);
      ObjectSetInteger(0, m_optimizer_name, OBJPROP_FONTSIZE, m_font_size);
      ObjectSetString(0, m_optimizer_name, OBJPROP_FONT, m_font_name);
      ObjectSetInteger(0, m_optimizer_name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
     }

   ObjectSetString(0, m_optimizer_name, OBJPROP_TEXT, optimizer);
  }

//+------------------------------------------------------------------+
//| Get signal status string                                         |
//+------------------------------------------------------------------+
string CDisplayManager::GetSignalStatus()
  {
   if(m_signal_manager == NULL)
      return "Signal Manager: Not Available";

   string signal_status = "";

   // Get RSI value (assuming SignalManager has a method to get RSI)
   // This would need to be implemented in SignalManager
   signal_status += "RSI: --\n";  // Placeholder - would call m_signal_manager.GetRSI()

   // Get EMA value
   signal_status += "EMA: --\n";  // Placeholder - would call m_signal_manager.GetEMA()

   // Get current signal
   signal_status += "Signal: --";  // Placeholder - would call m_signal_manager.GetSignal()

   return signal_status;
  }

//+------------------------------------------------------------------+
//| Get position summary string                                      |
//+------------------------------------------------------------------+
string CDisplayManager::GetPositionSummary()
  {
   int total_positions = PositionsTotal();
   string summary = "Total: " + IntegerToString(total_positions) + "\n";

   if(total_positions > 0)
     {
      double total_profit = 0.0;
      for(int i = 0; i < total_positions; i++)
        {
         if(m_position_info.SelectByIndex(i))
           {
            if(m_position_info.Symbol() == m_symbol)
              {
               total_profit += m_position_info.Profit();
               summary += StringFormat("%s: %.2f lots @ %.5f\n",
                                      (m_position_info.PositionType() == POSITION_TYPE_BUY ? "BUY" : "SELL"),
                                      m_position_info.Volume(),
                                      m_position_info.PriceOpen());
              }
           }
        }
      summary += "Total P/L: " + DoubleToString(total_profit, 2);
     }
   else
     {
      summary += "No positions";
     }

   return summary;
  }

//+------------------------------------------------------------------+
//| Get account summary string                                       |
//+------------------------------------------------------------------+
string CDisplayManager::GetAccountSummary()
  {
   string summary = "Balance: " + DoubleToString(AccountInfoDouble(ACCOUNT_BALANCE), 2) + "\n";
   summary += "Equity: " + DoubleToString(AccountInfoDouble(ACCOUNT_EQUITY), 2) + "\n";
   summary += "Margin: " + DoubleToString(AccountInfoDouble(ACCOUNT_MARGIN), 2) + "\n";
   summary += "Free Margin: " + DoubleToString(AccountInfoDouble(ACCOUNT_MARGIN_FREE), 2) + "\n";
   summary += "Leverage: " + IntegerToString((int)AccountInfoInteger(ACCOUNT_LEVERAGE));

   return summary;
  }

//+------------------------------------------------------------------+
//| Get parameter summary string                                     |
//+------------------------------------------------------------------+
string CDisplayManager::GetParameterSummary()
  {
   string params = "";

   // These would be passed from EA inputs or stored in a config
   params += "SL: --\n";  // Would need access to StopLoss input
   params += "TP: --\n";  // Would need access to TakeProfit input
   params += "RSI: --\n"; // Would need access to RSIPeriod input
   params += "EMA: --";   // Would need access to EMAPeriod input

   return params;
  }

//+------------------------------------------------------------------+
//| Get optimizer summary string                                     |
//+------------------------------------------------------------------+
string CDisplayManager::GetOptimizerSummary()
  {
   if(m_gold_optimizer == NULL)
      return "Gold Optimizer: Not Available";

   string optimizer_status = "";

   // Get market condition
   ENUM_MARKET_CONDITION condition = m_gold_optimizer.GetMarketCondition();
   string condition_str = "Unknown";
   switch(condition)
     {
      case MARKET_CONDITION_LOW_VOLATILITY:
         condition_str = "Low Volatility";
         break;
      case MARKET_CONDITION_NORMAL_VOLATILITY:
         condition_str = "Normal Volatility";
         break;
      case MARKET_CONDITION_HIGH_VOLATILITY:
         condition_str = "High Volatility";
         break;
      case MARKET_CONDITION_EXTREME_VOLATILITY:
         condition_str = "Extreme Volatility";
         break;
     }
   optimizer_status += "Condition: " + condition_str + "\n";

   // Get optimized parameters
   optimizer_status += "Opt SL: " + DoubleToString(m_gold_optimizer.GetOptimizedStopLoss(), 1) + "\n";
   optimizer_status += "Opt TP: " + DoubleToString(m_gold_optimizer.GetOptimizedTakeProfit(), 1) + "\n";
   optimizer_status += "Opt RSI: " + IntegerToString(m_gold_optimizer.GetOptimizedRSIPeriod());

   return optimizer_status;
  }
//+------------------------------------------------------------------+
