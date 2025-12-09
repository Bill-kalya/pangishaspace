// Flutter UI Code for Pangisha Space Screens

import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';

void main() {
  runApp(PangishaApp());
}

class PangishaApp extends StatelessWidget {
  const PangishaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomeScreen(),
    );
  }
}
