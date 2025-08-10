import 'package:eonix/screens/order_screen.dart';
import 'package:eonix/screens/stock_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eonix/providers/market_provider.dart';
import 'package:eonix/acces_pages/splash_screen.dart';
import 'package:eonix/acces_pages/login_page.dart';
import 'package:eonix/acces_pages/home_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => MarketProvider(),
      child: EonixApp(),
    ),
  );
}

class EonixApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Désactive le bandeau de debug
      title: 'Eonix',
      theme: ThemeData(primarySwatch: Colors.indigo),
      initialRoute: '/splash',
      onGenerateRoute: (settings) {
        if (settings.name == '/splash') {
          return MaterialPageRoute(builder: (_) => SplashScreen());
        }
        if (settings.name == '/login') {
          return MaterialPageRoute(builder: (_) => LoginPage());
        }
        if (settings.name == '/home') {
          final userName = settings.arguments as String;
          return MaterialPageRoute(builder: (_) => HomePage(userName: userName));
        }
        if (settings.name == '/detail') {
          final args = settings.arguments as Map<String, dynamic>;
          final symbol = args['symbol'] as String;
          return MaterialPageRoute(
            builder: (_) => StockDetailScreen(symbol: symbol),
          );
        }
        if (settings.name == '/order') {
          final args = settings.arguments as Map<String, dynamic>;
          final symbol = args['symbol'] as String;
          // Remplace OrderScreen par le nom réel de ton écran de passage d'ordre
          return MaterialPageRoute(
            builder: (_) => OrderScreen(symbol: symbol),
          );
        }
        return null;
      },
    );
  }
}