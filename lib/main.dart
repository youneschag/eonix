import 'package:flutter/material.dart';
import 'package:eonix/pages/splash_screen.dart';
import 'package:eonix/pages/login_page.dart';
import 'package:eonix/pages/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
        return null;
      },
    );
  }
}
