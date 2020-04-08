import 'package:bertonlite/screen/loginpage.dart';
import 'package:bertonlite/screen/splash.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Berton Alimentos',
      home: SplashScreen(),
    );
  }
}

