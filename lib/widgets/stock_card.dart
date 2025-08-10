import 'package:flutter/material.dart';

class StockCard extends StatelessWidget {
  final String symbol;
  final String name;
  final double price;
  final double qty;
  final VoidCallback? onTap;

  const StockCard({
    required this.symbol,
    required this.name,
    required this.price,
    required this.qty,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final holdingText = qty > 0 ? ' • ${qty.toStringAsFixed(2)} pts' : '';
    return Card(
      child: ListTile(
        onTap: onTap,
        title: Text('$symbol — $name'),
        subtitle: Text('Prix: ${price.toStringAsFixed(2)} MAD$holdingText'),
        trailing: Icon(Icons.chevron_right),
      ),
    );
  }
}
