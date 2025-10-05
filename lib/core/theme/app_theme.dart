import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ColorPalette {
  const ColorPalette({
    required this.background,
    required this.surface,
    required this.card,
    required this.chat,
    required this.accent,
    required this.highlight,
    required this.navbar,
    required this.textPrimary,
    required this.textOnSurface,
    required this.caution,
  });

  final Color background;
  final Color surface;
  final Color card;
  final Color chat;
  final Color accent;
  final Color highlight;
  final Color navbar;
  final Color textPrimary;
  final Color textOnSurface;
  final Color caution;

  static ColorPalette colorful() => const ColorPalette(
        background: Color(0xFFF7F453),
        surface: Color(0xFFFEF7D4),
        card: Color(0xFF82C93C),
        chat: Color(0xFFF97453),
        accent: Color(0xFF82C93C),
        highlight: Color(0xFF000000),
        navbar: Color(0xFFFEF7D4),
        textPrimary: Color(0xFF000000),
        textOnSurface: Color(0xFF000000),
        caution: Color(0xFFF97453),
      );

  static ColorPalette monochrome() => const ColorPalette(
        background: Color(0xFFF2F2F2),
        surface: Color(0xFFE5E5E5),
        card: Color(0xFFCCCCCC),
        chat: Color(0xFF999999),
        accent: Color(0xFF111111),
        highlight: Color(0xFF000000),
        navbar: Color(0xFFD9D9D9),
        textPrimary: Color(0xFF000000),
        textOnSurface: Color(0xFF000000),
        caution: Color(0xFF444444),
      );
}

class AppTheme {
  static ThemeData buildTheme({required bool isMonochrome}) {
    final palette = isMonochrome ? ColorPalette.monochrome() : ColorPalette.colorful();
    final textTheme = TextTheme(
      displayLarge: GoogleFonts.bebasNeue(fontSize: 58, letterSpacing: 2.4, color: palette.textPrimary),
      displayMedium: GoogleFonts.bebasNeue(fontSize: 42, letterSpacing: 2.0, color: palette.textPrimary),
      headlineMedium: GoogleFonts.bebasNeue(fontSize: 36, letterSpacing: 1.8, color: palette.textPrimary),
      bodyLarge: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: palette.textPrimary),
      bodyMedium: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: palette.textPrimary),
      bodySmall: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: palette.textPrimary),
      titleLarge: GoogleFonts.bebasNeue(fontSize: 30, letterSpacing: 1.6, color: palette.textPrimary),
      titleMedium: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700, color: palette.textPrimary),
      labelLarge: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700, color: palette.textPrimary),
    );

    return ThemeData(
      useMaterial3: false,
      scaffoldBackgroundColor: palette.background,
      primaryColor: palette.accent,
      textTheme: textTheme,
      colorScheme: ColorScheme.light(
        primary: palette.accent,
        secondary: palette.card,
        surface: palette.surface,
        background: palette.background,
        error: palette.caution,
        onPrimary: palette.textPrimary,
        onSecondary: palette.textPrimary,
        onSurface: palette.textOnSurface,
        onBackground: palette.textPrimary,
        onError: palette.textPrimary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: palette.background,
        elevation: 0,
        titleTextStyle: textTheme.headlineMedium,
        iconTheme: IconThemeData(color: palette.textPrimary, size: 28),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: palette.navbar,
        selectedItemColor: palette.textPrimary,
        unselectedItemColor: palette.textPrimary.withOpacity(0.5),
        selectedLabelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w700),
        unselectedLabelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
      ),
      inputDecorationTheme: InputDecorationTheme(
        fillColor: palette.surface,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.black, width: 3),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.black, width: 3),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.black, width: 3),
        ),
      ),
    );
  }
}
