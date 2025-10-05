import 'package:flutter/material.dart';

class LocaleText {
  const LocaleText({required this.en, required this.ar});

  final String en;
  final String ar;

  String resolve(Locale locale) => locale.languageCode == 'ar' ? ar : en;
}

extension LocaleTextListX on Iterable<LocaleText> {
  List<String> resolveAll(Locale locale) => map((item) => item.resolve(locale)).toList();
}
