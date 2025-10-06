import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/services/settings_service.dart';
import '../../../translations/app_translations.dart';

class SettingsController extends GetxController {
  final SettingsService _settingsService = Get.find<SettingsService>();

  ThemeMode get themeMode => _settingsService.themeMode;
  Locale get locale => _settingsService.locale;

  Future<void> changeTheme(ThemeMode mode) async {
    await _settingsService.updateTheme(mode);
    Get.snackbar('theme'.tr, 'snackbar_theme'.tr, snackPosition: SnackPosition.BOTTOM);
  }

  Future<void> changeLocale(Locale locale) async {
    await _settingsService.updateLocale(locale);
    Get.updateLocale(locale);
    Get.snackbar('language'.tr, 'snackbar_language'.tr, snackPosition: SnackPosition.BOTTOM);
  }

  List<Locale> get locales => AppTranslations.supportedLocales;
}
