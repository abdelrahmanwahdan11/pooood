import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

/// A reusable color palette that mirrors the marketplace visual system.
///
/// The palette is intentionally exposed in a standalone file so it can be
/// imported into any Flutter + GetX project without pulling in the rest of the
/// marketplace code base. Each getter returns a concrete palette that you can
/// use to paint custom widgets outside of the generated ThemeData objects.
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

  /// Full-color palette that matches the bright art direction of the app.
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

  /// Grayscale variant requested by the brief (also aliased as [monochrome]).
  static ColorPalette dark() => const ColorPalette(
        background: Color(0xFF2B2B2B),
        surface: Color(0xFF3D3D3D),
        card: Color(0xFF4F4F4F),
        chat: Color(0xFF606060),
        accent: Color(0xFFEBD671),
        highlight: Color(0xFFF7F7F7),
        navbar: Color(0xFF1F1F1F),
        textPrimary: Color(0xFFF5F5F5),
        textOnSurface: Color(0xFFEAEAEA),
        caution: Color(0xFFFF7A66),
      );

  /// Backwards compatible alias for the older naming used inside the project.
  static ColorPalette monochrome() => dark();
}

/// Centralized theme factory that outputs fully configured [ThemeData] objects
/// matching the design system (typography, borders, and the 2.5D hard shadow).
///
/// How to reuse in another Flutter + GetX app:
/// 1. Import this file: `import 'core/theme/marketplace_theme_presets.dart';`
/// 2. Put the controller in memory: `final theme =
///    Get.put(MarketplaceThemeController());`
/// 3. Wrap your GetMaterialApp with `Obx` and feed `theme.activeTheme` into the
///    `theme` parameter.
/// 4. Drop [MarketplaceThemeToggleButton] anywhere in the UI to flip modes.
///
/// 🔧 **خطوات الاستخدام داخل أي مشروع Flutter/GetX آخر:**
/// ١. استورد الملف: `import 'core/theme/marketplace_theme_presets.dart';`
/// ٢. سجِّل المتحكم: `final theme = Get.put(MarketplaceThemeController());`
/// ٣. لف `GetMaterialApp` داخل `Obx` ثم مرر `theme.activeTheme` إلى الخاصية `theme`.
/// ٤. استخدم [MarketplaceThemeToggleButton] كزر جاهز لتبديل الوضعين في أي شاشة.
class MarketplaceThemes {
  static ThemeData colorful() => _buildTheme(ColorPalette.colorful(), Brightness.light);

  static ThemeData dark() => _buildTheme(ColorPalette.dark(), Brightness.dark);

  static ThemeData _buildTheme(ColorPalette palette, Brightness brightness) {
    final textTheme = TextTheme(
      displayLarge: GoogleFonts.bebasNeue(
        fontSize: 58,
        letterSpacing: 2.4,
        color: palette.textPrimary,
      ),
      displayMedium: GoogleFonts.bebasNeue(
        fontSize: 42,
        letterSpacing: 2.0,
        color: palette.textPrimary,
      ),
      headlineMedium: GoogleFonts.bebasNeue(
        fontSize: 36,
        letterSpacing: 1.8,
        color: palette.textPrimary,
      ),
      bodyLarge: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: palette.textPrimary,
      ),
      bodyMedium: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: palette.textPrimary,
      ),
      bodySmall: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: palette.textPrimary,
      ),
      titleLarge: GoogleFonts.bebasNeue(
        fontSize: 30,
        letterSpacing: 1.6,
        color: palette.textPrimary,
      ),
      titleMedium: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: palette.textPrimary,
      ),
      labelLarge: GoogleFonts.poppins(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: palette.textPrimary,
      ),
    );

    return ThemeData(
      useMaterial3: false,
      scaffoldBackgroundColor: palette.background,
      primaryColor: palette.accent,
      textTheme: textTheme,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: palette.accent,
        onPrimary: palette.textPrimary,
        secondary: palette.card,
        onSecondary: palette.textPrimary,
        error: palette.caution,
        onError: palette.textPrimary,
        background: palette.background,
        onBackground: palette.textPrimary,
        surface: palette.surface,
        onSurface: palette.textOnSurface,
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

/// Lightweight controller that can be dropped into any GetX project to manage
/// the active marketplace theme. The controller exposes the [activeTheme] and
/// the [palette] that correspond to the current mode.
class MarketplaceThemeController extends GetxController {
  MarketplaceThemeController({bool startDark = false}) {
    isDark.value = startDark;
  }

  final RxBool isDark = false.obs;

  ThemeData get activeTheme => isDark.value ? MarketplaceThemes.dark() : MarketplaceThemes.colorful();

  ColorPalette get palette => isDark.value ? ColorPalette.dark() : ColorPalette.colorful();

  void toggleTheme() => isDark.toggle();
}

/// A reusable button that matches the 2.5D aesthetic and flips between the
/// colorful and dark palettes. It intentionally avoids repo-specific
/// dependencies so you can copy it into any project.
class MarketplaceThemeToggleButton extends StatelessWidget {
  const MarketplaceThemeToggleButton({
    super.key,
    required this.isDark,
    required this.onToggle,
  });

  final bool isDark;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final ColorPalette palette = isDark ? ColorPalette.dark() : ColorPalette.colorful();
    final textStyle = Theme.of(context).textTheme.bodySmall ??
        GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: palette.textPrimary);

    return SizedBox(
      height: 52,
      child: Stack(
        children: [
          Positioned(
            top: 6,
            left: 6,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(18),
              ),
            ),
          ),
          Positioned.fill(
            child: Material(
              color: palette.surface,
              borderRadius: BorderRadius.circular(18),
              child: InkWell(
                onTap: onToggle,
                borderRadius: BorderRadius.circular(18),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 3),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isDark ? Icons.dark_mode : Icons.light_mode,
                        color: palette.highlight,
                        size: 22,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        isDark ? 'Dark Theme' : 'Color Theme',
                        style: textStyle.copyWith(color: palette.textPrimary),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
