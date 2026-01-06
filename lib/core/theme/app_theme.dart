import 'package:flutter/material.dart';

class AppTheme {
  // Shared typography scale
  static const String _fontFamily = 'Roboto';
  static const TextTheme _textTheme = TextTheme(
    headlineMedium: TextStyle(fontFamily: _fontFamily, fontSize: 20, fontWeight: FontWeight.w700),
    titleLarge: TextStyle(fontFamily: _fontFamily, fontSize: 18, fontWeight: FontWeight.w600),
    titleMedium: TextStyle(fontFamily: _fontFamily, fontSize: 16, fontWeight: FontWeight.w600),
    bodyMedium: TextStyle(fontFamily: _fontFamily, fontSize: 14, fontWeight: FontWeight.w500),
    bodySmall: TextStyle(fontFamily: _fontFamily, fontSize: 13, fontWeight: FontWeight.w400),
    labelSmall: TextStyle(fontFamily: _fontFamily, fontSize: 11, fontWeight: FontWeight.w500),
  );

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: const Color(0xFFEEF2F6), // Cool Grey (Premium Muted)
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF0277BD),
      brightness: Brightness.light,
      primary: const Color(0xFF0277BD),
      secondary: const Color(0xFF00ACC1),
      error: const Color(0xFFD32F2F),
      surface: const Color(0xFFEEF2F6),   // Match background
    ),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: Color(0xFFEEF2F6), // Single Tone
      foregroundColor: Colors.black87,
    ),
    textTheme: _textTheme,
    cardTheme: CardThemeData(
      color: Colors.white,
      surfaceTintColor: Colors.white,
      shadowColor: Colors.black12,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: const Color(0xFF1E1E2C), // Dark Background
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF0277BD),
      brightness: Brightness.dark,
      primary: const Color(0xFF0277BD),
      secondary: const Color(0xFF00ACC1),
      error: const Color(0xFFD32F2F),
      surface: const Color(0xFF1E1E2C),   // Match background
    ),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: Color(0xFF1E1E2C), // Match background
      foregroundColor: Colors.white,
    ),
    textTheme: _textTheme.apply(
      bodyColor: Colors.white,
      displayColor: Colors.white,
    ),
    cardTheme: CardThemeData(
      color: const Color(0xFF252538),
      surfaceTintColor: const Color(0xFF252538),
      shadowColor: Colors.black54,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}
