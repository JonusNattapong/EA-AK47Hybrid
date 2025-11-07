# First Time Setup Guide

This guide will help you properly configure EA-AK47Hybrid for the first time after installation.

## 🎯 Prerequisites

Before proceeding with setup:
- [ ] EA-AK47Hybrid is installed and compiled
- [ ] MetaTrader 5 is running with XAU/USD chart
- [ ] Demo account is available for testing
- [ ] Basic understanding of forex trading

## 📊 Chart Preparation

### Step 1: Open Gold Chart
1. **Launch MetaTrader 5**
2. **Open Market Watch** (Ctrl+M)
3. **Find XAU/USD** (Gold vs US Dollar)
4. **Right-click XAU/USD → Chart Window**
5. **Set timeframe to H1** (recommended)

### Step 2: Chart Settings
```
Timeframe: H1 (recommended) or H4
Chart Type: Candlestick or Bar
Colors: Default (or your preference)
Indicators: Keep minimal (EA handles technical analysis)
```

### Step 3: Account Verification
- **Ensure sufficient margin** (minimum $1000 recommended)
- **Verify leverage** (1:100 or higher preferred)
- **Check spread on XAU/USD** (should be reasonable)
- **Confirm account type** (Demo for testing, Live for real trading)

## ⚙️ EA Attachment and Configuration

### Step 1: Attach EA to Chart
1. **Open Navigator** (Ctrl+N)
2. **Expand Expert Advisors**
3. **Find "EA-AK47Hybrid"**
4. **Drag to XAU/USD H1 chart**

### Step 2: Basic Parameters Setup

#### Essential Trading Parameters
```mq5
// Risk Management
LotSize = 0.01;           // Start with micro lots
UseFixedLot = true;       // Fixed lot size for beginners
RiskPercent = 1.0;        // 1% risk per trade

// Stop Loss & Take Profit
StopLoss = 120;           // 120 points (conservative)
TakeProfit = 250;         // 250 points target
```

#### Technical Indicators
```mq5
// RSI Settings
RSIPeriod = 21;           // Longer period for gold trends
RSIOverbought = 75;       // Overbought level
RSIOversold = 25;         // Oversold level

// Trend Filter
UseTrendFilter = true;    // Enable EMA trend filter
EMAPeriod = 100;          // Strong trend confirmation
```

### Step 3: Enable Protection Features

#### Risk Protection
```mq5
// Trailing Stop
UseTrailingStop = true;   // Enable dynamic stops
TrailingMode = TRAILING_MODE_ATR;  // ATR-based trailing
TrailingDistance = 1.5;   // 1.5x ATR multiplier

// Breakeven
UseBreakeven = true;      // Enable breakeven moves
BreakevenTrigger = 50.0;  // Trigger at 50 points profit
BreakevenOffset = 5.0;    // 5 point offset
```

#### Market Filters
```mq5
// News Filter
UseNewsFilter = true;     // Avoid high-impact news
NewsAvoidanceMinutes = 30; // 30 minutes before/after

// Time Filter
UseTimeFilter = true;     // Trading hours restriction
TradingStartHour = 2;     // Start at 2:00 UTC
TradingEndHour = 20;      // End at 20:00 UTC
```

### Step 4: Advanced Features Setup

#### Position Management
```mq5
// Partial Closes
UsePartialClose = true;   // Enable partial position closes
PartialCloseTrigger = 100.0; // Close partial at 100 points
PartialClosePercent = 0.4;   // Close 40% of position

// Multiple Take Profits
UseMultipleTP = true;     // Enable multiple TP levels
TP1_Profit = 90.0;        // First TP at 90 points
TP1_Volume = 0.3;         // Close 30% at TP1
TP2_Profit = 180.0;       // Second TP at 180 points
TP2_Volume = 0.4;         // Close 40% at TP2
TP3_Profit = 270.0;       // Third TP at 270 points
TP3_Volume = 0.3;         // Close 30% at TP3
```

#### Display Settings
```mq5
// Chart Overlay
UseDisplay = true;        // Enable monitoring overlay
DisplayTextColor = clrWhite;    // White text
DisplayFontSize = 8;      // Standard font size
DisplayFontName = "Arial"; // Clean font
```

## 🧪 Testing Configuration

### Step 1: Demo Testing Setup
1. **Switch to Demo Account**
2. **Attach EA with above settings**
3. **Enable "Algo Trading" button** (green circle)
4. **Monitor Expert tab** for messages
5. **Observe overlay display**

### Step 2: Initial Validation
- [ ] EA attaches without errors
- [ ] Overlay appears on chart
- [ ] No error messages in Expert tab
- [ ] Account information displays correctly
- [ ] Time filters allow current trading

### Step 3: Signal Testing
- **Wait for market movement**
- **Monitor signal indicators** in overlay
- **Check if EA recognizes signals**
- **Verify position opening logic**

## 🔧 Parameter Optimization

### Conservative Approach (Recommended for Beginners)
```mq5
// Lower risk, wider stops
LotSize = 0.01;
StopLoss = 150;      // Wider stops
TakeProfit = 200;    // Lower targets
TrailingDistance = 1.0;  // Conservative trailing
```

### Balanced Approach
```mq5
// Moderate risk
LotSize = 0.02;
StopLoss = 120;
TakeProfit = 250;
TrailingDistance = 1.5;
```

### Aggressive Approach (Advanced Users Only)
```mq5
// Higher risk, tighter stops
LotSize = 0.05;
StopLoss = 80;
TakeProfit = 400;
TrailingDistance = 2.0;
```

## 🛡️ Safety Checks

### Pre-Launch Checklist
- [ ] **Account Balance**: Sufficient funds ($500+ recommended)
- [ ] **Margin Requirements**: Check free margin
- [ ] **Spread**: Verify XAU/USD spread is reasonable
- [ ] **Connection**: Stable internet connection
- [ ] **Time Zone**: Correct broker time settings

### Risk Management Verification
- [ ] **Max Drawdown**: Set account limits
- [ ] **Daily Loss Limit**: Implement stop-loss rules
- [ ] **Position Size**: Never risk more than 2% per trade
- [ ] **Correlation**: Monitor USD strength impact

### System Validation
- [ ] **VPS**: Consider for 24/7 operation
- [ ] **Backup**: Save settings and configurations
- [ ] **Updates**: Check for EA updates regularly
- [ ] **Logs**: Monitor expert logs regularly

## 📈 Performance Monitoring

### Daily Checks
1. **Review Expert Tab** for errors or warnings
2. **Check Account Balance** and equity
3. **Monitor Win/Loss Ratio**
4. **Review Trade History**

### Weekly Analysis
1. **Performance Statistics**
2. **Parameter Effectiveness**
3. **Market Condition Adaptation**
4. **Optimization Opportunities**

## 🚨 Emergency Procedures

### If EA Malfunctions
1. **Disable Auto Trading** immediately
2. **Close all positions** manually if needed
3. **Detach EA** from chart
4. **Check Expert logs** for error details
5. **Contact support** if issues persist

### Account Protection
- **Set account stop-loss** at broker level
- **Monitor margin levels** continuously
- **Have emergency funds** available
- **Regular backup** of settings

## 🎯 Next Steps

After successful setup:

1. **Run Demo Tests** for 1-2 weeks
2. **Analyze Performance** metrics
3. **Fine-tune Parameters** based on results
4. **Gradually Increase** lot sizes
5. **Consider Live Trading** when confident

## 📞 Getting Help

If you encounter issues during setup:

- **Check [Troubleshooting](Troubleshooting)** page
- **Review [FAQ](Frequently-Asked-Questions)**
- **Search existing [Issues](https://github.com/JonusNattapong/EA-AK47Hybrid/issues)**
- **Create new issue** if problem persists

---

**Setup Complete!** Your EA-AK47Hybrid is now configured for safe and effective gold trading. Remember: start small, monitor closely, and never risk more than you can afford to lose.