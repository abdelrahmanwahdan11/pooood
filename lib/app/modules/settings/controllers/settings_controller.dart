/*
  هذا الملف يدير إعدادات التطبيق مثل اللغة والوضع اللوني والتفضيلات المحفوظة.
  يمكن توسيعه لإضافة مزامنة سحابية أو إعدادات حساب متقدمة.
*/
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/theme_service.dart' as core_theme;
import '../../../data/services/storage_service.dart';

class SettingsController extends GetxController {
  final themeMode = ThemeMode.system.obs;
  final isOffline = false.obs;
  final notificationsEnabled = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadSettings();
  }

  void _loadSettings() {
    final settings = StorageService.to.getSettings();
    final theme = settings['theme_mode'] as String?;
    if (theme == 'dark') {
      themeMode.value = ThemeMode.dark;
    } else if (theme == 'light') {
      themeMode.value = ThemeMode.light;
    }
    isOffline.value = settings['offline'] as bool? ?? false;
    notificationsEnabled.value = settings['notifications'] as bool? ?? false;
  }

  Future<void> setTheme(ThemeMode mode) async {
    themeMode.value = mode;
    await Get.find<core_theme.ThemeService>().setTheme(mode);
  }

  Future<void> toggleOffline(bool value) async {
    isOffline.value = value;
    final settings = StorageService.to.getSettings();
    settings['offline'] = value;
    await StorageService.to.saveSettings(settings);
  }

  Future<void> toggleNotifications(bool value) async {
    notificationsEnabled.value = value;
    final settings = StorageService.to.getSettings();
    settings['notifications'] = value;
    await StorageService.to.saveSettings(settings);
  }

  void changeLanguage(Locale locale) {
    Get.updateLocale(locale);
    final settings = StorageService.to.getSettings();
    settings['locale'] = locale.languageCode;
    StorageService.to.saveSettings(settings);
  }
}
