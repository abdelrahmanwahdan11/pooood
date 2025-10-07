import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../translations/app_translations.dart';

class SettingsService extends GetxService {
  static const _keyTheme = 'theme_mode';
  static const _keyLocale = 'locale';
  static const _keyOnboarding = 'onboarding_complete';
  static const _keyDisplayName = 'display_name';
  static const _keyEmail = 'display_email';
  static const _keyStreak = 'daily_reflection_streak';
  static const _keyLastReflection = 'daily_reflection_last';

  final _themeMode = ThemeMode.system.obs;
  final _locale = const Locale('ar').obs;
  final _onboardingComplete = false.obs;
  final _displayName = 'Isabella'.obs;
  final _email = 'isabella@mindmirror.app'.obs;
  final _streakCount = 0.obs;
  final _lastReflection = Rx<DateTime?>(null);
  late SharedPreferences _prefs;

  ThemeMode get themeMode => _themeMode.value;
  Locale get locale => _locale.value;
  bool get hasCompletedOnboarding => _onboardingComplete.value;
  String get displayName => _displayName.value;
  String get email => _email.value;
  int get streakCount => _streakCount.value;
  DateTime? get lastReflection => _lastReflection.value;
  RxString get displayNameRx => _displayName;
  RxString get emailRx => _email;
  RxInt get streakRx => _streakCount;

  Future<SettingsService> init() async {
    _prefs = await SharedPreferences.getInstance();
    await AppTranslations.preload();
    _loadTheme();
    _loadLocale();
    _loadOnboarding();
    _loadProfile();
    _loadReflection();
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

  void _loadProfile() {
    _displayName.value = _prefs.getString(_keyDisplayName) ?? _displayName.value;
    _email.value = _prefs.getString(_keyEmail) ?? _email.value;
  }

  void _loadReflection() {
    _streakCount.value = _prefs.getInt(_keyStreak) ?? 0;
    final last = _prefs.getString(_keyLastReflection);
    if (last != null) {
      _lastReflection.value = DateTime.tryParse(last);
    }
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

  Future<void> updateDisplayName(String name) async {
    _displayName.value = name;
    await _prefs.setString(_keyDisplayName, name);
  }

  Future<void> updateEmail(String value) async {
    _email.value = value;
    await _prefs.setString(_keyEmail, value);
  }

  Future<void> registerReflection({bool reset = false}) async {
    if (reset) {
      _streakCount.value = 0;
      _lastReflection.value = null;
      await _prefs.remove(_keyStreak);
      await _prefs.remove(_keyLastReflection);
      return;
    }

    final now = DateTime.now();
    final last = _lastReflection.value;
    if (last != null) {
      final difference = now.difference(DateTime(last.year, last.month, last.day)).inDays;
      if (difference == 1) {
        _streakCount.value += 1;
      } else if (difference > 1) {
        _streakCount.value = 1;
      }
    } else {
      _streakCount.value = 1;
    }
    _lastReflection.value = now;
    await _prefs.setInt(_keyStreak, _streakCount.value);
    await _prefs.setString(_keyLastReflection, now.toIso8601String());
  }
}
