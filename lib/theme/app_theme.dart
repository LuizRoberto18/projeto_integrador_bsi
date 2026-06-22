import 'package:flutter/material.dart';

class AppTheme {
  // Brand colors
  static const primary   = Color(0xFF1D4ED8); // blue-700
  static const secondary = Color(0xFF059669); // green-600
  static const accent    = Color(0xFFF59E0B); // amber-500
  static const error     = Color(0xFFDC2626); // red-600
  static const background = Color(0xFFF1F5F9);
  static const surface   = Color(0xFFFFFFFF);

  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    fontFamily: 'Lexend',
    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      primary: primary,
      secondary: secondary,
      error: error,
      surface: surface,
    ),
    scaffoldBackgroundColor: background,
    appBarTheme: const AppBarTheme(
      backgroundColor: surface,
      elevation: 0,
      centerTitle: false,
      iconTheme: IconThemeData(color: Color(0xFF1E293B)),
      titleTextStyle: TextStyle(
        fontFamily: 'Lexend',
        fontWeight: FontWeight.w700,
        fontSize: 18,
        color: Color(0xFF1E293B),
      ),
    ),
    cardTheme: CardThemeData(
      color: surface,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontFamily: 'Lexend', fontWeight: FontWeight.w600, fontSize: 15),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primary,
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        side: const BorderSide(color: primary),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: primary, width: 2)),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: surface,
      selectedItemColor: primary,
      unselectedItemColor: Color(0xFF94A3B8),
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
  );

  static ThemeData get highContrastTheme => ThemeData(
    useMaterial3: true,
    fontFamily: 'Lexend',
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFFFFFF00),
      secondary: Color(0xFFFFFF00),
      surface: Color(0xFF0D0D0D),
      error: Color(0xFFFF4444),
    ),
    scaffoldBackgroundColor: Colors.black,
  );
}