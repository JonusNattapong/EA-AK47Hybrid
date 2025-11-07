//+------------------------------------------------------------------+
//|                                           NewsFilterManager.mqh |
//|                        Copyright 2025, zombitx64 |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, zombitx64"
#property link      "https://www.mql5.com"
#property version   "1.00"

//--- Include necessary libraries
#include <Trade\PositionInfo.mqh>

//--- Struct for news events
struct SNewsEvent
  {
   string            name;                 // News event name
   int               day_of_week;          // Day of week (0-6, Sunday=0)
   int               hour;                 // Hour of event (0-23)
   int               minute;               // Minute of event (0-59)
   int               avoidance_minutes;    // Minutes to avoid before/after event
   bool              enabled;              // Enable/disable this event
  };

//+------------------------------------------------------------------+
//| Class CNewsFilterManager                                         |
//| Purpose: Manages news event filtering to avoid trading during   |
//|          high-impact news releases                               |
//+------------------------------------------------------------------+
class CNewsFilterManager
  {
private:
   string             m_symbol;
   bool               m_enabled;
   int                m_total_events;
   SNewsEvent         m_news_events[20];   // Array for up to 20 news events

   //--- Internal methods
   bool               IsNewsTime(datetime current_time);
   datetime           GetNextWeekday(int day_of_week, int hour, int minute);
   void               InitializeDefaultEvents();

public:
   //--- Constructor/Destructor
                     CNewsFilterManager();
                    ~CNewsFilterManager();

   //--- Initialization
   bool               Init(string symbol, bool enabled = true);

   //--- Main methods
   bool               CanTrade();          // Check if trading is allowed (no news)
   bool               IsEnabled() { return m_enabled; }

   //--- Configuration methods
   void               SetEnabled(bool enabled) { m_enabled = enabled; }
   bool               AddNewsEvent(string name, int day_of_week, int hour, int minute,
                                  int avoidance_minutes, bool enabled = true);
   bool               RemoveNewsEvent(int index);
   void               ClearAllEvents();
   int                GetTotalEvents() { return m_total_events; }
   string             GetEventInfo(int index);
  };

//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CNewsFilterManager::CNewsFilterManager()
  {
   m_symbol = "";
   m_enabled = false;
   m_total_events = 0;

   //--- Initialize default high-impact news events for 2025
   InitializeDefaultEvents();
  }

//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CNewsFilterManager::~CNewsFilterManager()
  {
  }

//+------------------------------------------------------------------+
//| Initialize the news filter manager                              |
//+------------------------------------------------------------------+
bool CNewsFilterManager::Init(string symbol, bool enabled = true)
  {
   m_symbol = symbol;
   m_enabled = enabled;

   return true;
  }

//+------------------------------------------------------------------+
//| Initialize default high-impact news events                      |
//+------------------------------------------------------------------+
void CNewsFilterManager::InitializeDefaultEvents()
  {
   //--- Clear existing events
   m_total_events = 0;

   //--- Add major US economic events (typical high-impact news)
   // NFP (Non-Farm Payrolls) - First Friday of month
   AddNewsEvent("US NFP", FRIDAY, 13, 30, 60, true);  // 8:30 ET = 13:30 UTC

   // FOMC Meetings - typically first Tuesday of month
   AddNewsEvent("FOMC Meeting", TUESDAY, 14, 0, 120, true);  // 2:00 PM ET = 14:00 UTC

   // CPI (Consumer Price Index) - mid-month
   AddNewsEvent("US CPI", THURSDAY, 13, 30, 45, true);

   // Fed Chair Speeches - various dates
   AddNewsEvent("Fed Chair Speech", WEDNESDAY, 14, 0, 60, true);

   // ADP Employment - Wednesday before NFP
   AddNewsEvent("US ADP", WEDNESDAY, 13, 15, 30, true);

   // GDP - early in quarter
   AddNewsEvent("US GDP", THURSDAY, 13, 30, 45, true);

   // Retail Sales - mid-month
   AddNewsEvent("US Retail Sales", THURSDAY, 13, 30, 30, true);

   //--- Add major international events
   // BoE Rate Decision - Thursday
   AddNewsEvent("BoE Rate Decision", THURSDAY, 12, 0, 45, true);

   // ECB Rate Decision - Thursday
   AddNewsEvent("ECB Rate Decision", THURSDAY, 12, 45, 45, true);

   // Bank of Japan - Friday
   AddNewsEvent("BoJ Rate Decision", FRIDAY, 5, 0, 45, true);
  }

//+------------------------------------------------------------------+
//| Check if trading is allowed (not during news events)            |
//+------------------------------------------------------------------+
bool CNewsFilterManager::CanTrade()
  {
   if(!m_enabled || m_total_events == 0)
      return true;  // If disabled or no events, allow trading

   datetime current_time = TimeTradeServer();

   return !IsNewsTime(current_time);
  }

//+------------------------------------------------------------------+
//| Check if current time is within news avoidance period           |
//+------------------------------------------------------------------+
bool CNewsFilterManager::IsNewsTime(datetime current_time)
  {
   for(int i = 0; i < m_total_events; i++)
     {
      if(!m_news_events[i].enabled)
         continue;

      //--- Get the next occurrence of this news event
      datetime event_time = GetNextWeekday(m_news_events[i].day_of_week,
                                         m_news_events[i].hour,
                                         m_news_events[i].minute);

      //--- Check if current time is within avoidance period
      datetime avoidance_start = event_time - m_news_events[i].avoidance_minutes * 60;
      datetime avoidance_end = event_time + m_news_events[i].avoidance_minutes * 60;

      if(current_time >= avoidance_start && current_time <= avoidance_end)
        {
         Print("News avoidance active: ", m_news_events[i].name,
               " (Event time: ", TimeToString(event_time), ")");
         return true;
        }
     }

   return false;
  }

//+------------------------------------------------------------------+
//| Get the next occurrence of a specific weekday and time          |
//+------------------------------------------------------------------+
datetime CNewsFilterManager::GetNextWeekday(int day_of_week, int hour, int minute)
  {
   datetime current_time = TimeTradeServer();
   MqlDateTime time_struct;
   TimeToStruct(current_time, time_struct);

   //--- Calculate days until next occurrence of the specified weekday
   int days_ahead = (day_of_week - time_struct.day_of_week + 7) % 7;

   //--- If it's today, check if the time has passed
   if(days_ahead == 0)
     {
      datetime today_event = StringToTime(TimeToString(current_time, TIME_DATE) +
                                        " " + IntegerToString(hour, 2, '0') + ":" +
                                        IntegerToString(minute, 2, '0') + ":00");

      if(current_time > today_event)
         days_ahead = 7;  // Next week
     }

   //--- Calculate the event datetime
   datetime event_time = current_time + days_ahead * 86400;  // Add days in seconds
   TimeToStruct(event_time, time_struct);

   //--- Set the specific hour and minute
   time_struct.hour = hour;
   time_struct.min = minute;
   time_struct.sec = 0;

   return StructToTime(time_struct);
  }

//+------------------------------------------------------------------+
//| Add a news event to the list                                     |
//+------------------------------------------------------------------+
bool CNewsFilterManager::AddNewsEvent(string name, int day_of_week, int hour, int minute,
                                     int avoidance_minutes, bool enabled = true)
  {
   if(m_total_events >= 20)
     {
      Print("Maximum number of news events reached (20)");
      return false;
     }

   if(day_of_week < 0 || day_of_week > 6 || hour < 0 || hour > 23 || minute < 0 || minute > 59)
     {
      Print("Invalid news event parameters");
      return false;
     }

   m_news_events[m_total_events].name = name;
   m_news_events[m_total_events].day_of_week = day_of_week;
   m_news_events[m_total_events].hour = hour;
   m_news_events[m_total_events].minute = minute;
   m_news_events[m_total_events].avoidance_minutes = avoidance_minutes;
   m_news_events[m_total_events].enabled = enabled;

   m_total_events++;

   return true;
  }

//+------------------------------------------------------------------+
//| Remove a news event from the list                                |
//+------------------------------------------------------------------+
bool CNewsFilterManager::RemoveNewsEvent(int index)
  {
   if(index < 0 || index >= m_total_events)
      return false;

   //--- Shift remaining events
   for(int i = index; i < m_total_events - 1; i++)
      m_news_events[i] = m_news_events[i + 1];

   m_total_events--;

   return true;
  }

//+------------------------------------------------------------------+
//| Clear all news events                                            |
//+------------------------------------------------------------------+
void CNewsFilterManager::ClearAllEvents()
  {
   m_total_events = 0;
  }

//+------------------------------------------------------------------+
//| Get information about a specific news event                     |
//+------------------------------------------------------------------+
string CNewsFilterManager::GetEventInfo(int index)
  {
   if(index < 0 || index >= m_total_events)
      return "Invalid index";

   string info = m_news_events[index].name + " - " +
                "Day: " + IntegerToString(m_news_events[index].day_of_week) + ", " +
                "Time: " + IntegerToString(m_news_events[index].hour, 2, '0') + ":" +
                IntegerToString(m_news_events[index].minute, 2, '0') + ", " +
                "Avoidance: " + IntegerToString(m_news_events[index].avoidance_minutes) + " min, " +
                "Enabled: " + (m_news_events[index].enabled ? "Yes" : "No");

   return info;
  }
//+------------------------------------------------------------------+
