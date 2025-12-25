import 'package:adoan/Guard/home_page.dart';
import 'package:adoan/Guard/login_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      initialRoute: "/login",

      routes: {
        "/login": (context) => const LoginPage(),
        "/home": (context) => const HomePage(),
      },
    );
  }
}
