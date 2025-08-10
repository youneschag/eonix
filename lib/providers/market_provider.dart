import 'dart:async';
import 'package:flutter/material.dart';
import 'package:eonix/services/mock_market.dart';
import 'package:eonix/models/stock.dart';

class MarketProvider extends ChangeNotifier {
  final MockMarket _market = MockMarket();
  final Map<String, double> _positions = {}; // symbol -> quantity
  final List<Map<String, dynamic>> _orders = []; // simple order history

  Timer? _timer;
  List<Stock> _stocks = [];

  MarketProvider() {
    _stocks = _market.initialStocks;
  }

  List<Stock> get stocks => _stocks;
  Map<String, double> get positions => _positions;
  List<Map<String, dynamic>> get orders => List.unmodifiable(_orders);

  List<double> historyFor(String symbol) {
    return _market.historyFor(symbol);
  }

  void startMarket({Duration interval = const Duration(seconds: 2)}) {
    _timer?.cancel();
    _timer = Timer.periodic(interval, (_) {
      _market.tick();
      // sync provider copies
      final updated = _market.initialStocks;
      for (var s in updated) {
        final idx = _stocks.indexWhere((e) => e.symbol == s.symbol);
        if (idx >= 0) {
          _stocks[idx].price = s.price;
        }
      }
      notifyListeners();
    });
  }

  void stopMarket() {
    _timer?.cancel();
    _timer = null;
  }

  Stock? findBySymbol(String symbol) {
    return _stocks.firstWhere((s) => s.symbol == symbol, orElse: () => _stocks.first);
  }

  double portfolioValue() {
    double v = 0;
    for (var entry in _positions.entries) {
      final stock = findBySymbol(entry.key);
      if (stock != null) v += stock.price * entry.value;
    }
    return v;
  }

  void placeOrder({required String symbol, required double qty, required bool buy}) {
    final stock = findBySymbol(symbol);
    if (stock == null) return;
    final price = stock.price;
    final amount = price * qty;
    // update positions
    final prev = _positions[symbol] ?? 0.0;
    _positions[symbol] = buy ? prev + qty : (prev - qty).clamp(0.0, double.infinity);
    // store simple history
    _orders.insert(0, {
      'symbol': symbol,
      'qty': qty,
      'price': price,
      'type': buy ? 'BUY' : 'SELL',
      'timestamp': DateTime.now().toIso8601String(),
      'amount': amount,
    });
    notifyListeners();
  }
}
