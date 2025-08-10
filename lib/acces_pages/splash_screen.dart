import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), () async {
      //Navigator.pushReplacementNamed(context, '/login');
      Navigator.pushReplacementNamed(context, '/home', arguments: "username");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Image.asset('assets/EONIX.png', height: 300),
          SizedBox(height: 30),
          CircularProgressIndicator(color: Colors.indigo),
        ]),
      ),
    );
  }
}