import 'dart:convert';
import 'dart:ui';

import 'package:flutter/services.dart' show rootBundle;
import 'package:get/get.dart';

class AppTranslations extends Translations {
  AppTranslations(this._keys);

  final Map<String, Map<String, String>> _keys;

  static const supportedLocales = <Locale>[
    Locale('en', 'US'),
    Locale('ar', 'SA'),
  ];

  static const Locale fallbackLocale = Locale('en', 'US');

  static Future<AppTranslations> load() async {
    final map = <String, Map<String, String>>{};
    for (final locale in supportedLocales) {
      final content = await rootBundle.loadString('assets/locales/${locale.languageCode}.json');
      final decoded = jsonDecode(content) as Map<String, dynamic>;
      map['${locale.languageCode}_${locale.countryCode}'] = _flatten(decoded);
    }
    return AppTranslations(map);
  }

  @override
  Map<String, Map<String, String>> get keys => _keys;

  static Map<String, String> _flatten(Map<String, dynamic> source, [String prefix = '']) {
    final result = <String, String>{};
    source.forEach((key, value) {
      final compositeKey = prefix.isEmpty ? key : '$prefix.$key';
      if (value is Map<String, dynamic>) {
        result.addAll(_flatten(value, compositeKey));
      } else {
        result[compositeKey] = value.toString();
      }
    });
    return result;
  }
}
