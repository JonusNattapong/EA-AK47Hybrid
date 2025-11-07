//+------------------------------------------------------------------+
//|                                           TimeFilterManager.mqh |
//|                        Copyright 2023, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"

//--- Include necessary libraries
#include <Trade\PositionInfo.mqh>

//--- Enums (using built-in ENUM_DAY_OF_WEEK)

//+------------------------------------------------------------------+
//| Class CTimeFilterManager                                         |
//| Purpose: Manages trading time restrictions                      |
//+------------------------------------------------------------------+
class CTimeFilterManager
  {
private:
   string             m_symbol;
   bool               m_enabled;
   bool               m_allow_trading_hours;     // Use specific trading hours
   int                m_start_hour;              // Start hour (0-23)
   int                m_end_hour;                // End hour (0-23)
   bool               m_allow_weekend_trading;   // Allow trading on weekends
   bool               m_allow_specific_days[7];  // Allow trading on specific days
   bool               m_invert_filter;           // Invert the filter logic

   //--- Internal methods
   bool               IsWithinTradingHours();
   bool               IsAllowedDay();
   datetime           GetServerTime();

public:
   //--- Constructor/Destructor
                     CTimeFilterManager();
                    ~CTimeFilterManager();

   //--- Initialization
   bool               Init(string symbol, bool enabled = true,
                          bool allow_trading_hours = true, int start_hour = 8, int end_hour = 18,
                          bool allow_weekend_trading = false, bool invert_filter = false);

   //--- Main methods
   bool               CanTrade();                // Check if trading is allowed now
   bool               IsEnabled() { return m_enabled; }

   //--- Setters
   void               SetEnabled(bool enabled) { m_enabled = enabled; }
   void               SetTradingHours(int start_hour, int end_hour);
   void               SetWeekendTrading(bool allow) { m_allow_weekend_trading = allow; }
   void               SetDayFilter(int day_of_week, bool allow);
   void               SetInvertFilter(bool invert) { m_invert_filter = invert; }

   //--- Getters
   bool               GetTradingHours(int &start_hour, int &end_hour);
   bool               GetDayFilter(int day_of_week);
  };

//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CTimeFilterManager::CTimeFilterManager()
  {
   m_symbol = "";
   m_enabled = false;
   m_allow_trading_hours = true;
   m_start_hour = 8;
   m_end_hour = 18;
   m_allow_weekend_trading = false;
   m_invert_filter = false;

   //--- Initialize day filters (allow all weekdays by default)
   for(int i = 0; i < 7; i++)
      m_allow_specific_days[i] = (i >= MONDAY && i <= FRIDAY);
  }

//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CTimeFilterManager::~CTimeFilterManager()
  {
  }

//+------------------------------------------------------------------+
//| Initialize the time filter manager                               |
//+------------------------------------------------------------------+
bool CTimeFilterManager::Init(string symbol, bool enabled = true,
                             bool allow_trading_hours = true, int start_hour = 8, int end_hour = 18,
                             bool allow_weekend_trading = false, bool invert_filter = false)
  {
   m_symbol = symbol;
   m_enabled = enabled;
   m_allow_trading_hours = allow_trading_hours;
   m_start_hour = start_hour;
   m_end_hour = end_hour;
   m_allow_weekend_trading = allow_weekend_trading;
   m_invert_filter = invert_filter;

   //--- Validate hours
   if(m_start_hour < 0 || m_start_hour > 23 || m_end_hour < 0 || m_end_hour > 23)
     {
      Print("Error: Invalid trading hours specified");
      return false;
     }

   return true;
  }

//+------------------------------------------------------------------+
//| Check if trading is allowed at current time                     |
//+------------------------------------------------------------------+
bool CTimeFilterManager::CanTrade()
  {
   if(!m_enabled)
      return true;  // If disabled, allow all trading

   bool time_allowed = true;

   //--- Check trading hours
   if(m_allow_trading_hours)
      time_allowed &= IsWithinTradingHours();

   //--- Check day of week
   time_allowed &= IsAllowedDay();

   //--- Apply filter inversion if needed
   if(m_invert_filter)
      time_allowed = !time_allowed;

   return time_allowed;
  }

//+------------------------------------------------------------------+
//| Check if current time is within trading hours                    |
//+------------------------------------------------------------------+
bool CTimeFilterManager::IsWithinTradingHours()
  {
   datetime server_time = GetServerTime();
   MqlDateTime time_struct;
   TimeToStruct(server_time, time_struct);

   int current_hour = time_struct.hour;

   //--- Handle overnight sessions (e.g., 22:00 to 06:00)
   if(m_start_hour > m_end_hour)
     {
      // Overnight session
      return (current_hour >= m_start_hour || current_hour <= m_end_hour);
     }
   else
     {
      // Regular session
      return (current_hour >= m_start_hour && current_hour <= m_end_hour);
     }
  }

//+------------------------------------------------------------------+
//| Check if current day is allowed for trading                      |
//+------------------------------------------------------------------+
bool CTimeFilterManager::IsAllowedDay()
  {
   datetime server_time = GetServerTime();
   MqlDateTime time_struct;
   TimeToStruct(server_time, time_struct);

   int day_of_week = time_struct.day_of_week;

   //--- Check weekend trading
   if((day_of_week == SATURDAY || day_of_week == SUNDAY) && !m_allow_weekend_trading)
      return false;

   //--- Check specific day filter
   return m_allow_specific_days[day_of_week];
  }

//+------------------------------------------------------------------+
//| Get server time                                                  |
//+------------------------------------------------------------------+
datetime CTimeFilterManager::GetServerTime()
  {
   return TimeTradeServer();
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| Set trading hours                                                |
//+------------------------------------------------------------------+
void CTimeFilterManager::SetTradingHours(int start_hour, int end_hour)
  {
   if(start_hour >= 0 && start_hour <= 23 && end_hour >= 0 && end_hour <= 23)
     {
      m_start_hour = start_hour;
      m_end_hour = end_hour;
     }
   else
     {
      Print("Error: Invalid trading hours specified");
     }
  }

//+------------------------------------------------------------------+
//| Set day filter for specific day of week                          |
//+------------------------------------------------------------------+
void CTimeFilterManager::SetDayFilter(int day_of_week, bool allow)
  {
   if(day_of_week >= 0 && day_of_week <= 6)
      m_allow_specific_days[day_of_week] = allow;
   else
      Print("Error: Invalid day of week specified");
  }

//+------------------------------------------------------------------+
//| Get trading hours                                                |
//+------------------------------------------------------------------+
bool CTimeFilterManager::GetTradingHours(int &start_hour, int &end_hour)
  {
   start_hour = m_start_hour;
   end_hour = m_end_hour;
   return true;
  }

//+------------------------------------------------------------------+
//| Get day filter for specific day of week                          |
//+------------------------------------------------------------------+
bool CTimeFilterManager::GetDayFilter(int day_of_week)
  {
   if(day_of_week >= 0 && day_of_week <= 6)
      return m_allow_specific_days[day_of_week];
   else
      return false;
  }
//+------------------------------------------------------------------+
