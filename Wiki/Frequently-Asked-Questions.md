# Frequently Asked Questions (FAQ)

Welcome to the EA-AK47Hybrid FAQ! This page addresses the most common questions about the Expert Advisor. If you don't find your answer here, check the [Troubleshooting](Troubleshooting) guide or create an issue on [GitHub](https://github.com/JonusNattapong/EA-AK47Hybrid/issues).

## 📋 Table of Contents

- [General Questions](#general-questions)
- [Installation & Setup](#installation--setup)
- [Trading & Performance](#trading--performance)
- [Features & Configuration](#features--configuration)
- [Technical Issues](#technical-issues)
- [Legal & License](#legal--license)

## ❓ General Questions

### What is EA-AK47Hybrid?
EA-AK47Hybrid is a professional Expert Advisor designed specifically for trading Gold (XAU/USD) in MetaTrader 5. It uses advanced RSI and EMA indicators with intelligent risk management and market adaptation features optimized for the 2025 trading environment.

### Is it free to use?
The EA is available for personal, non-commercial use only. It is copyrighted by zombitx64 and cannot be sold, distributed, or modified without permission. See the [License](License) for complete terms.

### What makes it different from other EAs?
- **Gold-Specific Optimization**: Tailored for XAU/USD volatility and correlation patterns
- **2025 Market Adaptation**: Built for current Fed policy and economic conditions
- **Professional Features**: News filtering, dynamic optimization, comprehensive monitoring
- **Modular Architecture**: 11 specialized modules for reliability and extensibility

### Can I use it on other symbols?
Currently optimized for XAU/USD only. The framework supports expansion to other symbols, but parameters would need adjustment for different market conditions.

## 🛠️ Installation & Setup

### What are the system requirements?
- MetaTrader 5 (latest version recommended)
- Windows 7/8/10/11 or macOS with Wine
- 2GB RAM minimum, 4GB recommended
- Stable internet connection
- XAU/USD trading account

### How do I install the EA?
1. Download the latest release from [GitHub Releases](https://github.com/JonusNattapong/EA-AK47Hybrid/releases)
2. Extract files to your MetaTrader 5 `MQL5\Experts\` directory
3. Open MetaEditor (F4) and compile `EA-AK47Hybrid.mq5`
4. Restart MetaTrader 5 and attach to XAU/USD chart

### The EA doesn't appear in Navigator. What should I do?
- Restart MetaTrader 5 completely
- Ensure files are in the correct folders
- Recompile the EA (F7 in MetaEditor)
- Check for compilation errors
- Refresh the Navigator panel

### Can I use it on a VPS?
Yes, highly recommended for 24/7 operation. Ensure the VPS has MetaTrader 5 installed and proper configuration.

## 📈 Trading & Performance

### What is the expected performance?
Performance varies based on market conditions, but typical results show:
- Win Rate: 60-70%
- Profit Factor: 1.3-1.5
- Max Drawdown: 10-15%
- Average trade: +10-25 points

*Past performance doesn't guarantee future results. Always test thoroughly.*

### How much capital do I need?
Minimum $500 recommended for proper risk management. Start with smaller amounts and scale up based on performance.

### What lot size should I use?
Start with 0.01 lots (micro) and increase gradually. Never risk more than 1-2% of account per trade.

### Does it work in all market conditions?
Optimized for various conditions but performs best in:
- Trending markets with clear direction
- Moderate volatility periods
- During active trading hours (2:00-20:00 UTC)

May struggle in extreme volatility or during major news events (which it avoids).

## ⚙️ Features & Configuration

### What do the input parameters mean?
See the [Configuration](Configuration) guide for detailed explanations. Key parameters:
- `LotSize`: Position size
- `StopLoss/TakeProfit`: Risk management levels
- `RSIPeriod`: RSI calculation period
- `UseTrailingStop`: Enable dynamic stops
- `UseNewsFilter`: Avoid high-impact news

### How do I enable the chart overlay?
Set `UseDisplay = true` and customize colors/fonts as needed. The overlay shows real-time account info, positions, and signals.

### What is the news filter and how does it work?
The news filter automatically pauses trading before/after major economic events (ADP, NFP, FOMC, etc.) to avoid increased volatility and slippage.

### Can I customize the trading hours?
Yes, use `TradingStartHour` and `TradingEndHour` to set your preferred trading window. Default is 2:00-20:00 UTC.

### What is dynamic optimization?
The GoldOptimizer module automatically adjusts parameters based on current market volatility and trend conditions.

## 🐛 Technical Issues

### The EA won't attach to the chart. Why?
- Check if another EA is already attached
- Ensure account allows automated trading
- Verify chart is XAU/USD
- Restart MetaTrader 5
- Check Expert logs for specific errors

### I'm getting compilation errors. What now?
- Ensure all Include files are present
- Update MetaTrader 5 to latest version
- Check antivirus isn't blocking files
- Re-download the complete package
- Report specific errors on GitHub

### The overlay isn't showing. How to fix?
- Confirm `UseDisplay = true`
- Try different chart timeframes
- Restart the chart
- Check if other indicators are interfering
- Verify font settings are valid

### EA is using too much CPU. What can I do?
- Disable the display overlay temporarily
- Close unnecessary charts
- Use a VPS with better resources
- Reduce update frequency if possible

### Positions are closing at wrong levels. Why?
- Check broker's minimum stop levels
- Account for spread in volatile conditions
- Increase slippage allowance
- Verify parameter values are correct

## ⚖️ Legal & License

### Can I modify the EA?
No. Modification is strictly prohibited under the license terms. All rights reserved by zombitx64.

### Can I sell or distribute the EA?
No. Commercial use and distribution are not permitted. The EA is for personal use only.

### What if I find a bug?
Report it through [GitHub Issues](https://github.com/JonusNattapong/EA-AK47Hybrid/issues) with detailed information. Do not attempt to fix it yourself.

### Is there a warranty or guarantee?
No warranty or guarantee is provided. Use at your own risk. The author assumes no responsibility for losses.

### Can I share my settings with others?
You can share general experiences anonymously, but do not distribute the EA files or detailed configurations that could enable commercial use.

## 🎯 Quick Solutions

### EA Not Working
1. Restart MetaTrader 5
2. Recompile the EA
3. Check Expert logs
4. Verify account permissions
5. Test on demo account

### Poor Performance
1. Review market conditions
2. Adjust parameters conservatively
3. Enable all protection features
4. Monitor and optimize regularly
5. Consider market timing

### Technical Problems
1. Update MetaTrader 5
2. Check internet connection
3. Verify file integrity
4. Disable conflicting software
5. Use recommended settings

---

**Didn't find your answer?** Check the [Troubleshooting](Troubleshooting) guide or search existing [GitHub Issues](https://github.com/JonusNattapong/EA-AK47Hybrid/issues). For urgent issues, create a new issue with detailed information including your MetaTrader version, error messages, and steps to reproduce.

*This FAQ is regularly updated. Last updated: November 2025*