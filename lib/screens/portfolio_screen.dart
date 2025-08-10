import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eonix/providers/market_provider.dart';
import 'package:eonix/widgets/stock_card.dart';
import 'package:intl/intl.dart';

class PortfolioScreen extends StatelessWidget {
  final currency = NumberFormat.currency(locale: 'fr_FR', symbol: 'MAD ');

  @override
  Widget build(BuildContext context) {
    final market = Provider.of<MarketProvider>(context);
    final total = market.portfolioValue();
    final positions = market.positions;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Summary
          Card(
            elevation: 2,
            child: ListTile(
              title: Text('Valeur totale du portefeuille', style: TextStyle(fontSize: 16)),
              subtitle: Text(currency.format(total), style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              trailing: ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/market'),
                child: Text('Acheter'),
              ),
            ),
          ),
          SizedBox(height: 16),
          // Positions
          Expanded(
            child: positions.isEmpty
                ? Center(child: Text('Aucune position. Achetez votre première action !'))
                : ListView(
                    children: positions.entries.map((e) {
                      final stock = market.findBySymbol(e.key)!;
                      return StockCard(
                        symbol: stock.symbol,
                        name: stock.name,
                        price: stock.price,
                        qty: e.value,
                        onTap: () {
                          Navigator.pushNamed(context, '/detail', arguments: {'symbol': stock.symbol});
                        },
                      );
                    }).toList(),
                  ),
          ),
        ],
      ),
    );
  }
}
