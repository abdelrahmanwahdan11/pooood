import 'package:flutter/material.dart';

import '../../data/repositories/settings_repo.dart';

class AppTheme {
  static const Color background = Color(0xFFF0EFF2);
  static const Color onSurface = Color(0xFF222222);
  static const Color accentPrimary = Color(0xFFFBD545);
  static const Color accentSuccess = Color(0xFF7BD597);

  static ThemeData buildThemeData(SettingsRepository settingsRepository) {
    final density = settingsRepository.themeDensity;
    final base = ThemeData(
      useMaterial3: true,
      fontFamily: 'SF Pro Display',
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: accentPrimary,
        onPrimary: onSurface,
        secondary: accentSuccess,
        onSecondary: onSurface,
        surface: Colors.white.withOpacity(0.9),
        onSurface: onSurface,
        background: background,
        onBackground: onSurface,
        error: Colors.red.shade400,
        onError: Colors.white,
        tertiary: Colors.white,
        onTertiary: onSurface,
        surfaceVariant: Colors.white.withOpacity(0.8),
        outline: Colors.black.withOpacity(0.08),
        shadow: Colors.black.withOpacity(0.18),
      ),
      scaffoldBackgroundColor: background,
      visualDensity: density == ThemeDensity.compact
          ? VisualDensity.compact
          : VisualDensity.standard,
      textTheme: _buildTextTheme(),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: onSurface,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withOpacity(0.18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.12)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: accentPrimary, width: 1.4),
        ),
        labelStyle: TextStyle(
          color: onSurface.withOpacity(0.72),
          letterSpacing: 0.2,
        ),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        labelStyle: const TextStyle(fontWeight: FontWeight.w600),
        backgroundColor: Colors.white.withOpacity(0.24),
        selectedColor: accentPrimary.withOpacity(0.32),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white.withOpacity(0.2),
        elevation: 0,
        indicatorColor: accentPrimary.withOpacity(0.24),
        iconTheme: MaterialStateProperty.resolveWith(
          (states) => IconThemeData(
            color: states.contains(MaterialState.selected)
                ? onSurface
                : onSurface.withOpacity(0.7),
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.black.withOpacity(0.85),
        contentTextStyle: const TextStyle(color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
    return base.copyWith(
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: _FadeSlideTransitionsBuilder(),
          TargetPlatform.iOS: _FadeSlideTransitionsBuilder(),
          TargetPlatform.macOS: _FadeSlideTransitionsBuilder(),
          TargetPlatform.linux: _FadeSlideTransitionsBuilder(),
          TargetPlatform.windows: _FadeSlideTransitionsBuilder(),
        },
      ),
    );
  }

  static TextTheme _buildTextTheme() {
    const baseStyle = TextStyle(
      color: onSurface,
      letterSpacing: 0.1,
      fontWeight: FontWeight.w500,
    );
    return const TextTheme().copyWith(
      displayLarge: baseStyle.copyWith(fontSize: 42, fontWeight: FontWeight.w700),
      displayMedium: baseStyle.copyWith(fontSize: 34, fontWeight: FontWeight.w600),
      displaySmall: baseStyle.copyWith(fontSize: 30, fontWeight: FontWeight.w600),
      headlineMedium: baseStyle.copyWith(fontSize: 26, fontWeight: FontWeight.w600),
      headlineSmall: baseStyle.copyWith(fontSize: 22, fontWeight: FontWeight.w600),
      titleLarge: baseStyle.copyWith(fontSize: 20, fontWeight: FontWeight.w600),
      titleMedium: baseStyle.copyWith(fontSize: 18, fontWeight: FontWeight.w500),
      titleSmall: baseStyle.copyWith(fontSize: 16, fontWeight: FontWeight.w500),
      bodyLarge: baseStyle.copyWith(fontSize: 16, fontWeight: FontWeight.w400),
      bodyMedium: baseStyle.copyWith(fontSize: 14, fontWeight: FontWeight.w400),
      bodySmall: baseStyle.copyWith(fontSize: 13, fontWeight: FontWeight.w300),
      labelLarge: baseStyle.copyWith(fontSize: 14, fontWeight: FontWeight.w600),
      labelMedium: baseStyle.copyWith(fontSize: 12, fontWeight: FontWeight.w500),
      labelSmall: baseStyle.copyWith(fontSize: 11, fontWeight: FontWeight.w500),
    );
  }
}

class _FadeSlideTransitionsBuilder extends PageTransitionsBuilder {
  const _FadeSlideTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
    return FadeTransition(
      opacity: curved,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0.05, 0.05),
          end: Offset.zero,
        ).animate(curved),
        child: child,
      ),
    );
  }
}

enum ThemeDensity { cozy, compact }
