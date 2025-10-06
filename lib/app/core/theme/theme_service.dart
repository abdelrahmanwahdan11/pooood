/*
  هذا الملف ينظم التحكم في وضع الثيم وتخزينه بالتعاون مع خدمة التفضيلات.
  يمكن تطويره لدعم ثيمات متعددة أو مزامنة التفضيل مع الخادم.
*/
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/services/theme_service.dart' as data_theme;

class ThemeService extends GetxService {
  final _themeMode = ThemeMode.system.obs;

  ThemeMode get themeMode => _themeMode.value;

  Future<ThemeService> init() async {
    final stored = data_theme.ThemePreferencesService.to.getThemeMode();
    if (stored != null) {
      _themeMode.value = stored == 'dark'
          ? ThemeMode.dark
          : stored == 'light'
              ? ThemeMode.light
              : ThemeMode.system;
    }
    return this;
  }

  Future<void> toggleTheme() async {
    if (_themeMode.value == ThemeMode.dark) {
      _themeMode.value = ThemeMode.light;
      await data_theme.ThemePreferencesService.to.saveThemeMode('light');
    } else {
      _themeMode.value = ThemeMode.dark;
      await data_theme.ThemePreferencesService.to.saveThemeMode('dark');
    }
    Get.changeThemeMode(_themeMode.value);
  }

  Future<void> setTheme(ThemeMode mode) async {
    _themeMode.value = mode;
    final key = mode == ThemeMode.dark
        ? 'dark'
        : mode == ThemeMode.light
            ? 'light'
            : 'system';
    await data_theme.ThemePreferencesService.to.saveThemeMode(key);
    Get.changeThemeMode(mode);
  }
}
