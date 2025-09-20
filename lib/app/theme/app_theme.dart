import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF5D5FEF);
  static const Color secondary = Color(0xFF8E8FF5);
  static const Color surfaceLight = Color(0xF2FFFFFF);
  static const Color surfaceDark = Color(0xF21E1E1E);
  static const Color shadow = Color(0x1A000000);
}

class AppTheme {
  AppTheme._();

  static ThemeData lightTheme(Locale locale) => _buildTheme(locale, Brightness.light);

  static ThemeData darkTheme(Locale locale) => _buildTheme(locale, Brightness.dark);

  static ThemeData _buildTheme(Locale locale, Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: brightness,
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        background: isDark ? const Color(0xFF0F0F10) : const Color(0xFFF4F5F8),
        surface: isDark ? const Color(0xFF121315) : Colors.white,
      ),
      scaffoldBackgroundColor: isDark ? const Color(0xFF0F0F10) : const Color(0xFFF4F5F8),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: _textTheme(locale, brightness).titleMedium,
      ),
      cardTheme: CardTheme(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      tabBarTheme: TabBarTheme(
        indicator: UnderlineTabIndicator(
          borderRadius: BorderRadius.circular(999),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
          insets: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        ),
        labelColor: isDark ? Colors.white : Colors.black,
        unselectedLabelColor: (isDark ? Colors.white : Colors.black).withOpacity(.6),
        labelStyle: _textTheme(locale, brightness).titleSmall?.copyWith(fontWeight: FontWeight.w600),
        unselectedLabelStyle: _textTheme(locale, brightness).titleSmall,
      ),
      textTheme: _textTheme(locale, brightness),
    );
    return base;
  }

  static TextTheme _textTheme(Locale locale, Brightness brightness) {
    final isArabic = locale.languageCode.toLowerCase() == 'ar';
    final base = brightness == Brightness.dark ? ThemeData.dark().textTheme : ThemeData.light().textTheme;
    final themed = isArabic
        ? GoogleFonts.cairoTextTheme(base)
        : GoogleFonts.interTextTheme(base);
    return themed.apply(
      bodyColor: brightness == Brightness.dark ? Colors.white : const Color(0xFF1A1B1E),
      displayColor: brightness == Brightness.dark ? Colors.white : const Color(0xFF1A1B1E),
    );
  }
}
