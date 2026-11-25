import 'package:flutter/material.dart';

import 'companion_home_screen.dart';

void main() {
  runApp(const CompanionWebApp());
}

class CompanionWebApp extends StatelessWidget {
  const CompanionWebApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Atria Companion',
      theme: ThemeData(colorSchemeSeed: Colors.teal, useMaterial3: true),
      home: const CompanionHomeScreen(),
    );
  }
}