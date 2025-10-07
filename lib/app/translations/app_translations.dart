import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:get/get.dart';

class AppTranslations extends Translations {
  static final Locale fallbackLocale = const Locale('ar');
  static final supportedLocales = const [Locale('ar'), Locale('en')];

  static Future<Map<String, String>> _loadLocale(String code) async {
    final data = await rootBundle.loadString('assets/i18n/$code.json');
    return Map<String, String>.from(jsonDecode(data) as Map<String, dynamic>);
  }

  static Future<void> preload() async {
    for (final locale in supportedLocales) {
      final map = await _loadLocale(locale.languageCode);
      _cache[locale.languageCode] = map;
    }
  }

  static final Map<String, Map<String, String>> _cache = {};

  @override
  Map<String, Map<String, String>> get keys => _cache;
}
