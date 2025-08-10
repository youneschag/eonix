import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eonix/providers/market_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class StockDetailScreen extends StatelessWidget {
  final String symbol;
  StockDetailScreen({required this.symbol});

  @override
  Widget build(BuildContext context) {
    final market = Provider.of<MarketProvider>(context);
    final stock = market.findBySymbol(symbol)!;
    final hist = market.historyFor(symbol);
    final currency = NumberFormat.currency(locale: 'fr_FR', symbol: 'MAD ');

    final spots = List.generate(hist.length, (i) => FlSpot(i.toDouble(), hist[i]));

    return Scaffold(
      appBar: AppBar(
        title: Text('${stock.name} (${stock.symbol})', style: TextStyle(color: Colors.indigo)),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.indigo),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: ListTile(
                title: Text(currency.format(stock.price), style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                subtitle: Text('Cours actuel'),
                trailing: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/order', arguments: {'symbol': stock.symbol});
                  },
                  child: Text('Acheter'),
                ),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Graphique (simulé)'),
                      SizedBox(height: 8),
                      Expanded(
                        child: LineChart(
                          LineChartData(
                            minX: 0,
                            maxX: spots.isEmpty ? 1 : spots.length.toDouble() - 1,
                            minY: spots.map((s) => s.y).fold<double>(double.infinity, (a, b) => a < b ? a : b),
                            maxY: spots.map((s) => s.y).fold<double>(-double.infinity, (a, b) => a > b ? a : b),
                            lineBarsData: [
                              LineChartBarData(spots: spots, isCurved: true, dotData: FlDotData(show: false), barWidth: 2),
                            ],
                            gridData: FlGridData(show: true),
                            titlesData: FlTitlesData(show: false),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
