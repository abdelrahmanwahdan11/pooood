import 'package:flutter/material.dart';

import 'marketplace_theme_presets.dart';

export 'marketplace_theme_presets.dart'
    show ColorPalette, MarketplaceThemes, MarketplaceThemeController, MarketplaceThemeToggleButton;

class AppTheme {
  static ThemeData buildTheme({required bool isMonochrome}) {
    return isMonochrome ? MarketplaceThemes.dark() : MarketplaceThemes.colorful();
  }
}
