import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  static ThemeData light({bool highContrast = false}) {
    final baseScheme = const ColorScheme.light(
      primary: AppColors.primaryBlue,
      secondary: AppColors.primaryYellow,
      tertiary: AppColors.primaryPink,
      background: AppColors.lightBackground,
      surface: AppColors.surfaceLight,
    );
    final scheme = highContrast
        ? baseScheme.copyWith(
            primary: const Color(0xFF023E7D),
            onPrimary: Colors.white,
            secondary: const Color(0xFFB69100),
            surface: Colors.white,
            onSurface: AppColors.textDark,
          )
        : baseScheme;

    final textTheme = Typography.material2021(platform: TargetPlatform.android).black.apply(
          fontFamily: 'Gilroy',
          bodyColor: scheme.onSurface,
          displayColor: scheme.onSurface,
        );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: 'Gilroy',
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.background,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
      ),
      cardTheme: CardTheme(
        color: scheme.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: scheme.primary,
          textStyle: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: BorderSide(color: scheme.primary.withOpacity(0.08)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: BorderSide(color: scheme.primary.withOpacity(0.5)),
        ),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        labelStyle: textTheme.labelLarge,
        selectedColor: scheme.primary.withOpacity(0.15),
        side: BorderSide(color: scheme.primary.withOpacity(0.2)),
      ),
    );
  }

  static ThemeData dark({bool highContrast = false, bool sleepMode = false}) {
    final baseScheme = const ColorScheme.dark(
      primary: Color(0xFF6FA8FF),
      secondary: Color(0xFFFFE257),
      tertiary: Color(0xFFFF8A90),
      background: AppColors.darkBackground,
      surface: AppColors.surfaceDark,
    );
    final scheme = baseScheme.copyWith(
      primary: highContrast ? const Color(0xFF90C2FF) : baseScheme.primary,
      surface: highContrast ? const Color(0xFF1F1F28) : baseScheme.surface,
      background: sleepMode ? const Color(0xFF0C0C0C) : baseScheme.background,
    );

    final textTheme = Typography.material2021(platform: TargetPlatform.android).white.apply(
          fontFamily: 'Gilroy',
          bodyColor: scheme.onSurface,
          displayColor: scheme.onSurface,
        );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: 'Gilroy',
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.background,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
      ),
      cardTheme: CardTheme(
        color: scheme.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: scheme.secondary,
          textStyle: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: BorderSide(color: scheme.primary.withOpacity(0.12)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: BorderSide(color: scheme.primary.withOpacity(0.5)),
        ),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        labelStyle: textTheme.labelLarge,
        selectedColor: scheme.primary.withOpacity(0.25),
        side: BorderSide(color: scheme.primary.withOpacity(0.24)),
      ),
    );
  }
}
