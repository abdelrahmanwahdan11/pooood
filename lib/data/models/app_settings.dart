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

  factory AppSettings.fromMap(Map<String, dynamic> map) {
    ThemeMode parseThemeMode(dynamic value) {
      if (value is ThemeMode) return value;
      if (value is String) {
        return ThemeMode.values.firstWhere(
          (mode) => mode.name == value,
          orElse: () => ThemeMode.system,
        );
      }
      if (value is num) {
        final index = value.toInt().clamp(0, ThemeMode.values.length - 1);
        return ThemeMode.values[index];
      }
      return ThemeMode.system;
    }

    return AppSettings(
      localeCode: map['localeCode'] as String? ?? 'ar',
      distanceFilterKm: (map['distanceFilterKm'] as num?)?.toDouble() ?? 25,
      notificationsEnabled: map['notificationsEnabled'] as bool? ?? true,
      themeMode: parseThemeMode(map['themeMode']),
    );
  }

  Map<String, dynamic> toMap() => {
        'localeCode': localeCode,
        'distanceFilterKm': distanceFilterKm,
        'notificationsEnabled': notificationsEnabled,
        'themeMode': themeMode.name,
      };

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
