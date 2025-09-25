import 'dart:ui';

import 'package:flutter/material.dart';

class AppTheme {
  static const Color seedColor = Color(0xFF006989);
  static const Color surfaceTint = Colors.white;
  static const Color background = Color(0xFFeaebed);

  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.light,
      background: background,
      surface: Colors.white.withOpacity(0.94),
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: background,
      textTheme: Typography.material2021().black.apply(bodyColor: Colors.black87),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      iconTheme: const IconThemeData(color: seedColor),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: seedColor,
        unselectedItemColor: Colors.black45,
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedIconTheme: const IconThemeData(size: 26),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withOpacity(0.2),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
        ),
      ),
      cardTheme: CardTheme(
        color: Colors.white.withOpacity(0.45),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        elevation: 0,
      ),
    );
  }

  static ThemeData get darkTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.dark,
    );
    return ThemeData.dark().copyWith(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: const Color(0xFF101417),
    );
  }

  static ThemeData get light => lightTheme;
  static ThemeData get dark => darkTheme;

  static BoxDecoration glassDecoration({Color overlay = Colors.white24}) {
    return BoxDecoration(
      color: overlay,
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: Colors.white.withOpacity(0.12)),
      boxShadow: [
        BoxShadow(
          blurRadius: 18,
          spreadRadius: -4,
          offset: const Offset(0, 12),
          color: Colors.black.withOpacity(0.08),
        ),
      ],
    );
  }

  static ImageFilter glassBlur() => ImageFilter.blur(sigmaX: 18, sigmaY: 18);
}
