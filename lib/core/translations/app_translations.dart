import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AppTranslations extends Translations {
  static final Map<String, Map<String, String>> _translations = {};
  static bool _initialized = false;

  static Future<void> ensureInitialized() async {
    if (_initialized) return;
    const locales = ['en', 'ar'];
    for (final locale in locales) {
      final data = await rootBundle.loadString('assets/i18n/$locale.json');
      final Map<String, dynamic> map = json.decode(data) as Map<String, dynamic>;
      _translations[locale] = map.map((key, value) => MapEntry(key, value.toString()));
    }
    _initialized = true;
  }

  @override
  Map<String, Map<String, String>> get keys => _translations;
}
