import 'package:flutter/material.dart';

import '../theme/colors.dart';
import '../theme/typography.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData _baseTheme({required Brightness brightness}) {
    final isDark = brightness == Brightness.dark;
    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: AppColors.primary,
      onPrimary: AppColors.white,
      secondary: AppColors.accent,
      onSecondary: AppColors.black,
      background: isDark ? const Color(0xFF050505) : const Color(0xFFF6F7FB),
      onBackground: isDark ? AppColors.white : AppColors.black,
      surface: isDark ? const Color(0xFF0D0D17) : AppColors.white,
      onSurface: isDark ? AppColors.white : AppColors.black,
      error: Colors.redAccent,
      onError: AppColors.white,
    );
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.background,
      textTheme: AppTypography.textTheme.apply(
        bodyColor: colorScheme.onBackground,
        displayColor: colorScheme.onBackground,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.black.withOpacity(isDark ? 0.4 : 0.2),
        elevation: 0,
        iconTheme: IconThemeData(color: colorScheme.onBackground),
        titleTextStyle: AppTypography.textTheme.titleLarge?.copyWith(
          color: colorScheme.onBackground,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withOpacity(isDark ? 0.06 : 0.14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: AppColors.accent, width: 1.4),
        ),
        labelStyle: AppTypography.textTheme.bodyMedium,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          textStyle: AppTypography.textTheme.titleSmall,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.black.withOpacity(0.4),
        elevation: 0,
        selectedItemColor: AppColors.accent,
        unselectedItemColor: AppColors.gray,
        showUnselectedLabels: false,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: Colors.white.withOpacity(0.14),
        selectedColor: AppColors.accent.withOpacity(0.2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        labelStyle: AppTypography.textTheme.labelMedium,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: Colors.black.withOpacity(0.8),
        contentTextStyle: AppTypography.textTheme.bodyMedium?.copyWith(
          color: AppColors.white,
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static ThemeData get light => _baseTheme(brightness: Brightness.light);

  static ThemeData get dark => _baseTheme(brightness: Brightness.dark);
}
