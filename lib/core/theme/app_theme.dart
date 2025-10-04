import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/repositories/settings_repo.dart';

class AppTheme {
  static const Color background = Color(0xFF7CF2D3);
  static const Color onSurface = Color(0xFF081C24);
  static const Color accentPrimary = Color(0xFF141A37);
  static const Color accentSuccess = Color(0xFFFF6584);

  static ThemeData buildThemeData(SettingsRepository settingsRepository) {
    final density = settingsRepository.themeDensity;
    final base = ThemeData(
      useMaterial3: true,
      textTheme: _buildTextTheme(),
      fontFamily: GoogleFonts.readexPro().fontFamily,
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: accentPrimary,
        onPrimary: const Color(0xFFFAF9FB),
        secondary: const Color(0xFF00D9A6),
        onSecondary: onSurface,
        surface: const Color(0xFFF9FFFE),
        onSurface: onSurface,
        background: background,
        onBackground: onSurface,
        error: const Color(0xFFFF4D67),
        onError: Colors.white,
        tertiary: const Color(0xFFEEF7FF),
        onTertiary: onSurface,
        surfaceVariant: const Color(0xFFE8FFF7),
        outline: const Color(0x33081C24),
        shadow: const Color(0x29081C24),
      ),
      scaffoldBackgroundColor: background,
      visualDensity: density == ThemeDensity.compact
          ? VisualDensity.compact
          : VisualDensity.standard,
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: onSurface,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withOpacity(0.45),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.32)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.22)),
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
        labelStyle: GoogleFonts.readexPro(fontWeight: FontWeight.w600),
        backgroundColor: Colors.white.withOpacity(0.4),
        selectedColor: const Color(0xFF141A37).withOpacity(0.15),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white.withOpacity(0.35),
        elevation: 0,
        indicatorColor: const Color(0xFF141A37).withOpacity(0.24),
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
        contentTextStyle: GoogleFonts.readexPro(color: Colors.white),
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
    final base = GoogleFonts.readexProTextTheme();
    return base.copyWith(
      displayLarge: base.displayLarge?.copyWith(
        fontSize: 44,
        fontWeight: FontWeight.w700,
        color: onSurface,
      ),
      displayMedium: base.displayMedium?.copyWith(
        fontSize: 36,
        fontWeight: FontWeight.w600,
        color: onSurface,
      ),
      displaySmall: base.displaySmall?.copyWith(
        fontSize: 30,
        fontWeight: FontWeight.w600,
        color: onSurface,
      ),
      headlineMedium: base.headlineMedium?.copyWith(
        fontSize: 26,
        fontWeight: FontWeight.w600,
        color: onSurface,
      ),
      headlineSmall: base.headlineSmall?.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: onSurface,
      ),
      titleLarge: base.titleLarge?.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: onSurface,
      ),
      titleMedium: base.titleMedium?.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: onSurface,
      ),
      titleSmall: base.titleSmall?.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: onSurface,
      ),
      bodyLarge: base.bodyLarge?.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: onSurface,
      ),
      bodyMedium: base.bodyMedium?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: onSurface,
      ),
      bodySmall: base.bodySmall?.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: onSurface.withOpacity(0.8),
      ),
      labelLarge: base.labelLarge?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: onSurface,
      ),
      labelMedium: base.labelMedium?.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: onSurface,
      ),
      labelSmall: base.labelSmall?.copyWith(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: onSurface,
      ),
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
