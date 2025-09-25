import 'package:flutter/material.dart';

class AppSettings {
  const AppSettings({
    required this.localeCode,
    required this.distanceFilterKm,
    required this.notificationsEnabled,
    required this.themeMode,
  });

  final String localeCode;
  final double distanceFilterKm;
  final bool notificationsEnabled;
  final ThemeMode themeMode;

  AppSettings copyWith({
    String? localeCode,
    double? distanceFilterKm,
    bool? notificationsEnabled,
    ThemeMode? themeMode,
  }) {
    return AppSettings(
      localeCode: localeCode ?? this.localeCode,
      distanceFilterKm: distanceFilterKm ?? this.distanceFilterKm,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      themeMode: themeMode ?? this.themeMode,
    );
  }
}
