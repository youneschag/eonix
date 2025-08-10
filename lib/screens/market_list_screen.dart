import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eonix/providers/market_provider.dart';
import 'package:intl/intl.dart';
import 'package:eonix/widgets/stock_card.dart';

class MarketListScreen extends StatefulWidget {
  @override
  State<MarketListScreen> createState() => _MarketListScreenState();
}

class _MarketListScreenState extends State<MarketListScreen> {
  String filter = '';

  @override
  Widget build(BuildContext context) {
    final market = Provider.of<MarketProvider>(context);
    final currency = NumberFormat.currency(locale: 'fr_FR', symbol: 'MAD ');

    final list = market.stocks.where((s) {
      final q = filter.toLowerCase();
      return s.symbol.toLowerCase().contains(q) || s.name.toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      appBar: AppBar(title: Text("Analyse du marché")),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Rechercher action ou ETF',
              ),
              onChanged: (v) => setState(() => filter = v),
            ),
            SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: list.length,
                itemBuilder: (_, idx) {
                  final s = list[idx];
                  return StockCard(
                    symbol: s.symbol,
                    name: s.name,
                    price: s.price,
                    qty: (market.positions[s.symbol] ?? 0),
                    onTap: () => Navigator.pushNamed(
                      context,
                      '/detail',
                      arguments: {'symbol': s.symbol},
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
