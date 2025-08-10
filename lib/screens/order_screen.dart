import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eonix/providers/market_provider.dart';

class OrderScreen extends StatefulWidget {
  @override
  final String symbol;

  const OrderScreen({Key? key, required this.symbol}) : super(key: key);
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final qtyCtrl = TextEditingController(text: '1');
  bool isBuy = true;
  String symbol = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null && args.containsKey('symbol')) {
      symbol = args['symbol'] as String;
    }
  }

  @override
  Widget build(BuildContext context) {
    final market = Provider.of<MarketProvider>(context);
    final stock = symbol.isNotEmpty ? market.findBySymbol(symbol) : null;

    return Scaffold(
      appBar: AppBar(title: Text('Passer un ordre')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: stock == null
            ? Center(child: Text('Sélectionnez une valeur depuis le marché'))
            : Column(
                children: [
                  ListTile(
                    title: Text('${stock.name} (${stock.symbol})'),
                    subtitle: Text('Prix courant: ${stock.price.toStringAsFixed(2)} MAD'),
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      ChoiceChip(
                        label: Text('ACHAT'),
                        selected: isBuy,
                        onSelected: (v) => setState(() => isBuy = true),
                      ),
                      SizedBox(width: 8),
                      ChoiceChip(
                        label: Text('VENTE'),
                        selected: !isBuy,
                        onSelected: (v) => setState(() => isBuy = false),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: qtyCtrl,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(labelText: 'Quantité (actions)'),
                  ),
                  Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      final q = double.tryParse(qtyCtrl.text) ?? 0;
                      if (q <= 0) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Quantité invalide')));
                        return;
                      }
                      market.placeOrder(symbol: stock.symbol, qty: q, buy: isBuy);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Ordre exécuté (simulé)')));
                      Navigator.pop(context);
                    },
                    child: Text('Confirmer'),
                    style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 48)),
                  )
                ],
              ),
      ),
    );
  }
}
