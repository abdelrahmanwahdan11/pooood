import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../translations/app_translations.dart';

class SettingsService extends GetxService {
  static const _keyTheme = 'theme_mode';
  static const _keyLocale = 'locale';
  static const _keyOnboarding = 'onboarding_complete';

  final _themeMode = ThemeMode.system.obs;
  final _locale = const Locale('ar').obs;
  final _onboardingComplete = false.obs;
  late SharedPreferences _prefs;

  ThemeMode get themeMode => _themeMode.value;
  Locale get locale => _locale.value;
  bool get hasCompletedOnboarding => _onboardingComplete.value;

  Future<SettingsService> init() async {
    _prefs = await SharedPreferences.getInstance();
    await AppTranslations.preload();
    _loadTheme();
    _loadLocale();
    _loadOnboarding();
    return this;
  }

  void _loadTheme() {
    final stored = _prefs.getString(_keyTheme);
    switch (stored) {
      case 'light':
        _themeMode.value = ThemeMode.light;
        break;
      case 'dark':
        _themeMode.value = ThemeMode.dark;
        break;
      default:
        _themeMode.value = ThemeMode.system;
    }
  }

  void _loadLocale() {
    final code = _prefs.getString(_keyLocale);
    if (code != null) {
      _locale.value = Locale(code);
    }
  }

  void _loadOnboarding() {
    _onboardingComplete.value = _prefs.getBool(_keyOnboarding) ?? false;
  }

  Future<void> updateTheme(ThemeMode mode) async {
    _themeMode.value = mode;
    String value = 'system';
    if (mode == ThemeMode.light) value = 'light';
    if (mode == ThemeMode.dark) value = 'dark';
    await _prefs.setString(_keyTheme, value);
  }

  Future<void> updateLocale(Locale locale) async {
    _locale.value = locale;
    await _prefs.setString(_keyLocale, locale.languageCode);
  }

  Future<void> setOnboardingComplete() async {
    _onboardingComplete.value = true;
    await _prefs.setBool(_keyOnboarding, true);
  }
}
