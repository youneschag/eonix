import 'dart:async';
import 'dart:math';

import 'package:eonix/models/stock.dart';

class MockMarket {
  final Random _rng = Random();
  final List<Stock> _stocks = [
    Stock(symbol: 'ATW', name: 'Attijariwafa Bank', price: 520.0, market: 'CAS', changePercent: 0.02),
    Stock(symbol: 'BMCE', name: 'BMCE Bank', price: 210.0, market: 'CAS', changePercent: 0.03),
    Stock(symbol: 'CDG', name: 'CDG Capital', price: 140.0, market: 'CAS', changePercent: 0.025),
    Stock(symbol: 'MAR-ETF', name: 'ETF Maroc', price: 100.0, market: 'CAS', changePercent: 0.01),
    Stock(symbol: 'SP500-ETF', name: 'SP500 UCITS', price: 450.0, market: 'INT', changePercent: 0.012),
    Stock(symbol: 'NASDAQ-ETF', name: 'NASDAQ UCITS', price: 320.0, market: 'INT', changePercent: 0.015),
  ];

  // Keep limited history map: symbol -> list of price points (latest last)
  final Map<String, List<double>> _history = {};

  MockMarket() {
    for (var s in _stocks) {
      _history[s.symbol] = List.generate(30, (i) => (s.price * (1 - 0.01 + 0.002 * _rng.nextDouble())));
    }
  }

  List<Stock> get initialStocks => _stocks.map((s) => Stock(
        symbol: s.symbol,
        name: s.name,
        price: s.price,
        market: s.market,
        changePercent: s.changePercent,
      )).toList();

  List<double> historyFor(String symbol) {
    return _history[symbol] ?? [];
  }

  // simulate a tick: update prices randomly
  void tick() {
    for (var s in _stocks) {
      final vol = s.changePercent;
      final pct = ( (_rng.nextDouble() * 2 - 1) * vol ); // e.g. -vol..+vol
      final newPrice = (s.price * (1 + pct)).clamp(0.01, double.infinity);
      s.price = double.parse(newPrice.toStringAsFixed(2));
      final hist = _history[s.symbol]!;
      hist.add(s.price);
      if (hist.length > 60) hist.removeAt(0);
    }
  }
}
