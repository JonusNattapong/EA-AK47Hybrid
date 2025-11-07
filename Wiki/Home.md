# EA-AK47Hybrid Wiki

Welcome to the **EA-AK47Hybrid** documentation wiki! This comprehensive guide will help you understand, install, configure, and optimize your Expert Advisor for successful gold trading in 2025.

## 📖 Overview

**EA-AK47Hybrid** is a professional-grade Expert Advisor designed specifically for trading Gold (XAU/USD) in the 2025 market environment. Built with a modular architecture, it combines advanced technical analysis with intelligent risk management and market-adaptive features.

### 🎯 Key Features

- **2025 Gold Optimization**: Tailored for current market conditions
- **ATR-Based Trailing Stops**: Dynamic stop loss management
- **News Event Filtering**: Avoids trading during high-impact events
- **Multiple Take Profit Levels**: Advanced profit-taking strategies
- **Real-Time Display Overlay**: Professional monitoring dashboard
- **Dynamic Parameter Adjustment**: Market condition adaptation

## 🚀 Quick Start

### Installation
1. [Download the latest release](https://github.com/JonusNattapong/EA-AK47Hybrid/releases)
2. Copy files to your MetaTrader 5 `MQL5\Experts\` directory
3. Compile the EA in MetaEditor
4. Attach to XAU/USD H1 chart

### Basic Configuration
- **Symbol**: XAU/USD (Gold)
- **Timeframe**: H1 or H4
- **Risk**: Start with 1% per trade
- **Enable**: Display overlay and all protection features

## 📚 Documentation

### Getting Started
- [[Installation Guide|Installation]]
- [[First Time Setup|Setup]]
- [[Basic Configuration|Configuration]]

### Advanced Features
- [[Trailing Stop System|Trailing-Stops]]
- [[Breakeven Management|Breakeven]]
- [[News Filter System|News-Filter]]
- [[Multiple Take Profits|Multiple-TP]]
- [[Time Filters|Time-Filters]]

### Optimization
- [[Gold Market Analysis|Gold-Analysis]]
- [[Parameter Optimization|Optimization]]
- [[Backtesting Guide|Backtesting]]
- [[Risk Management|Risk-Management]]

### Troubleshooting
- [[Common Issues|Troubleshooting]]
- [[FAQ|Frequently-Asked-Questions]]
- [[Performance Monitoring|Performance]]

## 📊 Dashboard Overview

When enabled, the EA displays a comprehensive overlay showing:

```
┌─────────────────────────────────────┐
│ EA-AK47Hybrid v1.10 - Gold Trading  │
├─────────────────────────────────────┤
│ Status: Active                      │
│ Symbol: XAU/USD                     │
│ Timeframe: H1                       │
│ Server Time: 14:30                  │
├─────────────────────────────────────┤
│ Positions:                          │
│ Total: 2                            │
│ BUY: 0.05 lots @ 4008.50           │
│ SELL: 0.03 lots @ 4012.30           │
│ Total P/L: +45.67                   │
└─────────────────────────────────────┘
```

## ⚙️ Recommended Settings for 2025

### Conservative Settings
```mq5
Stop Loss: 120 points
Take Profit: 250 points
Trailing Mode: ATR (1.5x)
News Filter: Enabled (30min avoidance)
Multiple TP: Enabled
```

### Aggressive Settings
```mq5
Stop Loss: 80 points
Take Profit: 400 points
Trailing Mode: ATR (2.0x)
News Filter: Enabled (45min avoidance)
Multiple TP: Enabled (3 levels)
```

## 🔒 License & Copyright

This software is copyrighted © 2025 by **zombitx64**. All rights reserved.

- ✅ **Personal use**: Allowed for individual traders
- ❌ **Commercial use**: Strictly prohibited
- ❌ **Modification**: Not permitted without permission
- ❌ **Redistribution**: Not allowed

See [[License|License]] for complete terms.

## 📞 Support & Community

- **Issues**: [Report bugs](https://github.com/JonusNattapong/EA-AK47Hybrid/issues)
- **Discussions**: [Community forum](https://github.com/JonusNattapong/EA-AK47Hybrid/discussions)
- **Documentation**: [Contribute to wiki](https://github.com/JonusNattapong/EA-AK47Hybrid/wiki)

## 📈 Version History

### v1.10 (Latest)
- Complete 2025 gold trading optimization
- Professional display overlay
- News event filtering
- Dynamic parameter adjustment
- 11 specialized modules

### v1.00
- Initial modular architecture
- Basic RSI + EMA strategy
- Risk management system

---

**Happy Trading!** Remember to always test in a demo account first and never risk more than you can afford to lose.

*This wiki is maintained by the EA-AK47Hybrid development team.*