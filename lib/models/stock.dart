class Stock {
  final String symbol;
  final String name;
  double price; // mutable for simulation
  final String market; // "CAS" or "INT"
  final double changePercent; // base volatility

  Stock({
    required this.symbol,
    required this.name,
    required this.price,
    required this.market,
    required this.changePercent,
  });

  // snapshot for chart points
  Map<String, dynamic> toMap() => {
        'symbol': symbol,
        'name': name,
        'price': price,
        'market': market,
      };
}
