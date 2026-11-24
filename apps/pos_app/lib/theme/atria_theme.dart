import 'package:flutter/material.dart';

class AtriaTheme {
  static const _seedPurple = Color(0xFF5B4FCF);
  static const _accentOrange = Color(0xFFE67E22);

  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(
      seedColor: _seedPurple,
      brightness: Brightness.light,
      secondary: _accentOrange,
      tertiary: _accentOrange,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: Colors.grey.shade300),
        ),
      ),
    );
  }
}