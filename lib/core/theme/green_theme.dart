import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GreenPalette {
  static const Color primary = Color(0xFF1FAA59);
  static const Color secondary = Color(0xFF34C759);
  static const Color accent = Color(0xFFC7F9CC);
  static const Color darkSurface = Color(0xFF0F2E1B);
  static const Color lightSurface = Color(0xFFF2FFF6);
  static const List<Color> gradientPrimary = [
    Color(0xFF1FAA59),
    Color(0xFF34C759),
    Color(0xFFC7F9CC),
  ];
}

class GreenTheme {
  GreenTheme._();

  static ThemeData get light => _buildTheme(Brightness.light);
  static ThemeData get dark => _buildTheme(Brightness.dark);

  static ThemeData _buildTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor:
          isDark ? GreenPalette.darkSurface : GreenPalette.lightSurface,
      colorScheme: ColorScheme.fromSeed(
        brightness: brightness,
        seedColor: GreenPalette.primary,
        primary: GreenPalette.primary,
        secondary: GreenPalette.secondary,
        tertiary: GreenPalette.accent,
        background:
            isDark ? GreenPalette.darkSurface : GreenPalette.lightSurface,
      ),
      textTheme: _textTheme(brightness),
      fontFamily: GoogleFonts.inter().fontFamily,
    );

    return base.copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: base.textTheme.titleLarge?.copyWith(
          color: isDark ? Colors.white : const Color(0xFF0C1E13),
          fontWeight: FontWeight.w700,
        ),
        iconTheme: IconThemeData(
          color: isDark ? Colors.white : GreenPalette.primary,
        ),
      ),
      cardTheme: CardTheme(
        color: isDark
            ? Colors.white.withOpacity(0.08)
            : Colors.white.withOpacity(0.9),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: GreenPalette.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark
            ? Colors.white.withOpacity(0.08)
            : Colors.white.withOpacity(0.85),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: isDark
            ? Colors.black.withOpacity(0.45)
            : Colors.white.withOpacity(0.85),
        selectedItemColor: GreenPalette.primary,
        unselectedItemColor:
            isDark ? Colors.white70 : Colors.black.withOpacity(0.5),
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  static TextTheme _textTheme(Brightness brightness) {
    final base = brightness == Brightness.dark
        ? ThemeData.dark().textTheme
        : ThemeData.light().textTheme;
    final interTheme = GoogleFonts.interTextTheme(base).apply(
      bodyColor: brightness == Brightness.dark
          ? Colors.white
          : const Color(0xFF0C1E13),
      displayColor: brightness == Brightness.dark
          ? Colors.white
          : const Color(0xFF0C1E13),
    );
    final cairoTheme = GoogleFonts.cairoTextTheme(base);

    return interTheme.copyWith(
      displayLarge: cairoTheme.displayLarge,
      displayMedium: cairoTheme.displayMedium,
      displaySmall: cairoTheme.displaySmall,
      headlineLarge: cairoTheme.headlineLarge,
      headlineMedium: cairoTheme.headlineMedium,
      headlineSmall: cairoTheme.headlineSmall,
      titleLarge: interTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
      titleMedium: interTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
      titleSmall: interTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
    );
  }

  static LinearGradient get primaryGradient => const LinearGradient(
        colors: GreenPalette.gradientPrimary,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
}
