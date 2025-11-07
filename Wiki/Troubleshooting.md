# Troubleshooting Guide

This guide helps you resolve common issues with EA-AK47Hybrid. If you can't find a solution here, check the [FAQ](Frequently-Asked-Questions) or create an issue on [GitHub](https://github.com/JonusNattapong/EA-AK47Hybrid/issues).

## 📋 Quick Diagnosis

### Before Troubleshooting
- [ ] EA is compiled without errors
- [ ] MetaTrader 5 is updated to latest version
- [ ] XAU/USD chart has sufficient historical data
- [ ] Account has sufficient margin
- [ ] Internet connection is stable

## 🚫 Common Issues & Solutions

### EA Not Appearing in Navigator

**Symptoms:**
- EA-AK47Hybrid not visible in Expert Advisors list
- "Cannot find expert" error when attaching

**Solutions:**
1. **Restart MetaTrader 5** completely
2. **Check file location:**
   ```
   MQL5\Experts\EA-AK47Hybrid.mq5
   MQL5\Experts\Include\*.mqh (all module files)
   ```
3. **Recompile the EA:**
   - Open in MetaEditor (F4)
   - Press F7 to compile
   - Check for errors in "Errors" tab
4. **Refresh Navigator:**
   - Right-click Navigator → Refresh
   - Or restart terminal

### Compilation Errors

**Symptoms:**
- Red error messages during compilation
- EA shows as "Not Compiled" in Navigator

**Common Errors:**

#### "Include file not found"
```
Error: 'Include\IndicatorManager.mqh' - cannot open file
```
**Solution:**
- Ensure all `.mqh` files are in `MQL5\Experts\Include\`
- Check file permissions
- Re-download if files are corrupted

#### "Function must have a body"
```
Error: function 'SomeFunction' must have a body
```
**Solution:**
- Re-download the complete package
- Ensure all files are up to date
- Check for antivirus interference

#### "Array out of range"
```
Error: array out of range in 'SomeModule.mqh'
```
**Solution:**
- Restart MetaEditor
- Clean and rebuild
- Check MetaTrader 5 version compatibility

### EA Won't Attach to Chart

**Symptoms:**
- Drag-and-drop doesn't work
- "Expert Advisor is busy" message

**Solutions:**
1. **Close all charts** with the EA attached
2. **Restart MetaTrader 5**
3. **Check account permissions:**
   - Ensure account allows automated trading
   - Verify account type (Demo/Live)
4. **Template issues:**
   - Attach to clean chart (no other indicators)
   - Try different timeframes

### No Trading Signals

**Symptoms:**
- EA loads but doesn't open positions
- "Waiting for signal" in Expert tab

**Possible Causes:**

#### Time Filters Active
- Check `UseTimeFilter` settings
- Verify current time is within trading hours
- Check broker time zone

**Solution:**
```mq5
TradingStartHour = 2;    // Adjust for your timezone
TradingEndHour = 20;
```

#### News Filter Blocking
- Major economic events may be blocking trades
- Check Expert tab for "News avoidance active" messages

**Solution:**
- Wait for news events to pass
- Adjust `NewsAvoidanceMinutes` if needed
- Monitor economic calendar

#### Indicator Issues
- Insufficient historical data
- Wrong symbol (must be XAU/USD)

**Solution:**
- Download more historical data
- Ensure chart is XAU/USD
- Check indicator parameters

### Overlay Not Displaying

**Symptoms:**
- Chart overlay doesn't appear
- "Display Manager: Not Available" in logs

**Solutions:**
1. **Enable display:**
   ```mq5
   UseDisplay = true;
   ```
2. **Check chart properties:**
   - Ensure chart allows indicators
   - Try different timeframes
3. **Restart chart:**
   - Close and reopen XAU/USD chart
   - Reattach EA

### Poor Performance

**Symptoms:**
- High CPU usage
- Slow chart updates
- Frequent errors

**Solutions:**
1. **Optimize settings:**
   ```mq5
   DisplayFontSize = 7;  // Smaller font
   UseDisplay = false;   // Disable overlay temporarily
   ```
2. **Check system resources:**
   - Close unnecessary programs
   - Use VPS for 24/7 operation
3. **Update MetaTrader 5** to latest version

### Unexpected Stops/Losses

**Symptoms:**
- Positions closing at wrong levels
- Stop losses not working as expected

**Possible Issues:**

#### Spread Issues
- High spreads on XAU/USD
- Slippage during volatile periods

**Solution:**
- Increase `Slippage` parameter
- Trade during lower volatility periods

#### Broker Differences
- Different stop level requirements
- Variable spread conditions

**Solution:**
- Check broker specifications
- Adjust `StopLoss` and `TakeProfit` values

### Account Errors

**Symptoms:**
- "Not enough margin" errors
- "Invalid lots amount" messages

**Solutions:**
1. **Check account balance:**
   - Ensure sufficient funds
   - Calculate required margin

2. **Adjust lot size:**
   ```mq5
   LotSize = 0.01;  // Start smaller
   ```

3. **Verify leverage:**
   - Check account leverage
   - Confirm broker requirements

## 🔧 Advanced Troubleshooting

### Log Analysis

**Enable Detailed Logging:**
1. Open MetaTrader 5
2. Go to Tools → Options → Expert Advisors
3. Enable "Allow automated trading"
4. Enable "Allow DLL imports" (if needed)
5. Check "Disable automated trading when..." options

**Reading Expert Logs:**
- Press Ctrl+T to open Terminal
- Go to "Expert" tab
- Look for error messages and timestamps
- Note any patterns or recurring issues

### Memory Issues

**Symptoms:**
- "Out of memory" errors
- Terminal freezing or crashing

**Solutions:**
1. **Close unnecessary charts**
2. **Disable display overlay temporarily**
3. **Restart MetaTrader 5**
4. **Check system RAM** (4GB minimum recommended)

### Network Issues

**Symptoms:**
- "Connection lost" messages
- News filter not working

**Solutions:**
1. **Check internet connection**
2. **Disable news filter temporarily:**
   ```mq5
   UseNewsFilter = false;
   ```
3. **Use stable VPS connection**

## 🆘 Emergency Procedures

### If EA Goes Wrong
1. **Disable Auto Trading** (red circle button)
2. **Close all positions** manually if needed
3. **Detach EA** from all charts
4. **Save Expert logs** for analysis
5. **Contact support** with detailed information

### Account Protection
- Set broker-level stop losses
- Monitor account regularly
- Use demo account for testing
- Never risk more than you can afford

## 📞 Getting Help

### Self-Help Resources
- [[Installation Guide|Installation]]
- [[Setup Guide|Setup]]
- [[FAQ|Frequently-Asked-Questions]]
- [[Performance Guide|Performance]]

### Community Support
- **GitHub Issues:** [Report bugs](https://github.com/JonusNattapong/EA-AK47Hybrid/issues)
- **Discussions:** [Community forum](https://github.com/JonusNattapong/EA-AK47Hybrid/discussions)
- **Documentation:** [Wiki pages](https://github.com/JonusNattapong/EA-AK47Hybrid/wiki)

### When Reporting Issues
**Include this information:**
- MetaTrader 5 version and build
- Windows version
- EA version and settings
- Error messages (exact text)
- Steps to reproduce the issue
- Screenshot if applicable

## ✅ Prevention Tips

### Regular Maintenance
- Update MetaTrader 5 regularly
- Keep EA files updated
- Monitor account health
- Backup settings periodically

### Best Practices
- Start with demo account
- Use small lot sizes initially
- Monitor performance daily
- Take breaks during high volatility

---

**Still having issues?** Check the [FAQ](Frequently-Asked-Questions) or create a detailed issue report on GitHub. Most problems have simple solutions when diagnosed properly.