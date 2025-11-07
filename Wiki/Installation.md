# Installation Guide

This guide will walk you through installing and setting up EA-AK47Hybrid on your MetaTrader 5 platform.

## 📋 System Requirements

### Minimum Requirements
- **MetaTrader 5** platform (latest version recommended)
- **Windows 7/8/10/11** or **macOS** with Wine
- **RAM**: 2GB minimum, 4GB recommended
- **Internet Connection**: Required for real-time data and news filtering

### Recommended Specifications
- **CPU**: Dual-core 2.0 GHz or higher
- **RAM**: 8GB or more
- **Storage**: 500MB free space
- **VPS**: Recommended for 24/7 operation

## 📥 Download

### Option 1: GitHub Release (Recommended)
1. Visit the [Releases page](https://github.com/JonusNattapong/EA-AK47Hybrid/releases)
2. Download the latest version (`.zip` file)
3. Extract to a temporary folder

### Option 2: Clone Repository
```bash
git clone https://github.com/JonusNattapong/EA-AK47Hybrid.git
cd EA-AK47Hybrid
```

## 🛠️ Installation Steps

### Step 1: Locate MetaTrader 5 Directory

Find your MetaTrader 5 installation folder:

**Windows Default Location:**
```
C:\Program Files\MetaTrader 5\
```

**Alternative Locations:**
- Check the MetaTrader 5 icon properties
- Look in `%APPDATA%\MetaQuotes\Terminal\[TerminalID]\MQL5\`

### Step 2: Copy Files

1. **Navigate to Experts folder:**
   ```
   [MT5 Installation]\MQL5\Experts\
   ```

2. **Copy EA files:**
   - Copy `EA-AK47Hybrid.mq5` to the `Experts\` folder
   - Copy the entire `Include\` folder to `Experts\Include\`

3. **File Structure After Installation:**
   ```
   MQL5\Experts\
   ├── EA-AK47Hybrid.mq5
   └── Include\
       ├── IndicatorManager.mqh
       ├── TradeManager.mqh
       ├── SignalManager.mqh
       ├── RiskManager.mqh
       ├── TrailingStopManager.mqh
       ├── BreakevenManager.mqh
       ├── TimeFilterManager.mqh
       ├── PositionManager.mqh
       ├── NewsFilterManager.mqh
       ├── GoldOptimizer.mqh
       └── DisplayManager.mqh
   ```

### Step 3: Compile the EA

1. **Open MetaEditor:**
   - Press **F4** in MetaTrader 5, or
   - Go to `Tools → MetaQuotes Language Editor`

2. **Load the EA:**
   - File → Open → Navigate to `EA-AK47Hybrid.mq5`
   - Or drag the file into MetaEditor

3. **Compile:**
   - Press **F7**, or
   - Click the compile button (gear icon)

4. **Check for Errors:**
   - Look at the `Errors` tab
   - Ensure "0 errors, 0 warnings" message

### Step 4: Verify Installation

1. **Restart MetaTrader 5**
2. **Open Navigator panel** (Ctrl+N)
3. **Expand Expert Advisors**
4. **Find "EA-AK47Hybrid"** in the list
5. **Right-click → Attach to Chart**

## ⚙️ Initial Configuration

### Basic Settings
When attaching to a chart, configure these essential parameters:

```mq5
// Essential Settings
LotSize = 0.01;           // Start small
UseFixedLot = true;       // Use fixed lot size
RiskPercent = 1.0;        // 1% risk per trade

// Gold-Specific Settings
StopLoss = 120;           // 120 points for gold volatility
TakeProfit = 250;         // 250 points target
RSIPeriod = 21;           // Longer period for gold
EMAPeriod = 100;          // Strong trend filter
```

### Enable Protection Features
```mq5
// Enable all protection
UseTrailingStop = true;   // Dynamic stops
UseBreakeven = true;      // Profit protection
UseNewsFilter = true;     // News avoidance
UseTimeFilter = true;     // Trading hours
UseDisplay = true;        // Monitoring overlay
```

## 🧪 Testing Installation

### Demo Account Test
1. **Switch to Demo Account** in MetaTrader 5
2. **Attach EA to XAU/USD H1 chart**
3. **Enable "Algo Trading"** button
4. **Monitor the overlay** for proper display
5. **Check Expert tab** for any error messages

### Paper Trading
- Use a micro account with minimal lots
- Monitor performance for 1-2 weeks
- Adjust parameters based on results

## 🔧 Troubleshooting

### Common Issues

#### EA Not Appearing in Navigator
- **Solution**: Restart MetaTrader 5
- **Check**: Ensure files are in correct folders
- **Verify**: Compilation was successful

#### Compilation Errors
- **Check**: All Include files are present
- **Verify**: MetaEditor version compatibility
- **Update**: MetaTrader 5 to latest version

#### Overlay Not Showing
- **Check**: `UseDisplay = true`
- **Verify**: Chart timeframe supports indicators
- **Restart**: Terminal if needed

#### No Trading Signals
- **Check**: Time filters allow current time
- **Verify**: News filter not blocking trades
- **Monitor**: Expert tab for messages

### Error Messages

#### "Cannot load expert"
- Check file permissions
- Verify antivirus not blocking
- Ensure correct folder structure

#### "Array out of range"
- Check indicator parameters
- Verify sufficient historical data
- Restart terminal

## 📞 Support

If you encounter issues:

1. **Check the [Troubleshooting](Troubleshooting) page**
2. **Review [FAQ](Frequently-Asked-Questions)**
3. **Report issues** on [GitHub Issues](https://github.com/JonusNattapong/EA-AK47Hybrid/issues)

## ✅ Post-Installation Checklist

- [ ] Files copied to correct locations
- [ ] EA compiles without errors
- [ ] Appears in Navigator
- [ ] Attaches to chart successfully
- [ ] Overlay displays correctly
- [ ] Demo testing completed
- [ ] Parameters configured appropriately

---

**Installation Complete!** Your EA-AK47Hybrid is now ready for gold trading. Remember to start with small lots and gradually increase as you gain confidence in the system's performance.