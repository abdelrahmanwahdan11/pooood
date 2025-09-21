import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GlassTheme {
  static ThemeData get light {
    final base = ThemeData.light(useMaterial3: true);
    return base.copyWith(
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF4E8AFF),
        secondary: Color(0xFF72D5FF),
        background: Color(0xFFF4F6FB),
        surface: Color(0xFFFFFFFF),
        onPrimary: Colors.white,
        onSecondary: Colors.black,
        onBackground: Color(0xFF0E1726),
        onSurface: Color(0xFF0E1726),
      ),
      scaffoldBackgroundColor: const Color(0xFFF4F6FB),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white.withOpacity(0.2),
        elevation: 0,
        foregroundColor: const Color(0xFF0E1726),
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF0E1726),
        ),
      ),
      textTheme: _textTheme(Brightness.light),
      cardTheme: CardTheme(
        color: Colors.white.withOpacity(0.4),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white.withOpacity(0.3),
        selectedItemColor: const Color(0xFF4E8AFF),
        unselectedItemColor: const Color(0xFF7486A3),
        elevation: 0,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: Colors.white.withOpacity(0.2),
        labelStyle: GoogleFonts.inter(
          color: const Color(0xFF0E1726),
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
    );
  }

  static ThemeData get dark {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF8AB4FF),
        secondary: Color(0xFF5CE1E6),
        background: Color(0xFF0F172A),
        surface: Color(0xFF111A2E),
        onPrimary: Colors.black,
        onSecondary: Colors.black,
        onBackground: Colors.white,
        onSurface: Colors.white,
      ),
      scaffoldBackgroundColor: const Color(0xFF0F172A),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.black.withOpacity(0.2),
        elevation: 0,
        foregroundColor: Colors.white,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      textTheme: _textTheme(Brightness.dark),
      cardTheme: CardTheme(
        color: Colors.white.withOpacity(0.08),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.black.withOpacity(0.2),
        selectedItemColor: const Color(0xFF8AB4FF),
        unselectedItemColor: Colors.white70,
        elevation: 0,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: Colors.white.withOpacity(0.08),
        labelStyle: GoogleFonts.inter(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
    );
  }

  static TextTheme _textTheme(Brightness brightness) {
    final baseColor = brightness == Brightness.light ? const Color(0xFF0E1726) : Colors.white;
    return TextTheme(
      displayLarge: GoogleFonts.inter(fontSize: 48, fontWeight: FontWeight.w700, color: baseColor),
      displayMedium: GoogleFonts.inter(fontSize: 40, fontWeight: FontWeight.w700, color: baseColor),
      displaySmall: GoogleFonts.inter(fontSize: 32, fontWeight: FontWeight.w700, color: baseColor),
      headlineLarge: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.w600, color: baseColor),
      headlineMedium: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w600, color: baseColor),
      headlineSmall: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w600, color: baseColor),
      titleLarge: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600, color: baseColor),
      titleMedium: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: baseColor.withOpacity(0.9)),
      titleSmall: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: baseColor.withOpacity(0.85)),
      bodyLarge: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w500, color: baseColor.withOpacity(0.9)),
      bodyMedium: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: baseColor.withOpacity(0.8)),
      bodySmall: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w400, color: baseColor.withOpacity(0.7)),
      labelLarge: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: baseColor),
      labelMedium: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: baseColor.withOpacity(0.8)),
      labelSmall: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w600, color: baseColor.withOpacity(0.6)),
    );
  }
}

class GlassContainerStyle {
  final double blur;
  final double opacity;
  final Gradient gradient;
  final BorderRadius borderRadius;
  final Border border;

  const GlassContainerStyle({
    this.blur = 30,
    this.opacity = 0.2,
    this.gradient = const LinearGradient(
      colors: [Color(0x66FFFFFF), Color(0x33FFFFFF)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    this.borderRadius = const BorderRadius.all(Radius.circular(24)),
    this.border = const Border.fromBorderSide(BorderSide(color: Color(0x33FFFFFF))),
  });
}
