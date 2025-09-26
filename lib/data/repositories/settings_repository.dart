import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import '../models/app_settings.dart';

abstract class SettingsRepository {
  AppSettings load();
  void save(AppSettings settings);
}

class InMemorySettingsRepository implements SettingsRepository {
  InMemorySettingsRepository() : _box = GetStorage();

  final GetStorage _box;

  // Firebase integration placeholder:
  // To persist settings remotely, synchronize settings.toMap() with
  // a document in Firestore or Realtime Database once connected.

  @override
  AppSettings load() {
    final raw = _box.read('app_settings');
    if (raw is Map) {
      return AppSettings.fromMap(Map<String, dynamic>.from(raw));
    }
    final locale = _box.read<String>('locale') ?? 'ar';
    final distanceRaw = _box.read('distance_filter');
    final distance = (distanceRaw as num?)?.toDouble() ?? 10;
    final notifications = _box.read<bool>('notifications') ?? true;
    final themeModeIndex = _box.read<int>('theme_mode') ?? ThemeMode.light.index;
    final safeIndex = themeModeIndex.clamp(0, ThemeMode.values.length - 1);
    return AppSettings(
      localeCode: locale,
      distanceFilterKm: distance,
      notificationsEnabled: notifications,
      themeMode: ThemeMode.values[safeIndex],
    );
  }

  @override
  void save(AppSettings settings) {
    _box.write('app_settings', settings.toMap());
    _box.write('locale', settings.localeCode);
    _box.write('distance_filter', settings.distanceFilterKm);
    _box.write('notifications', settings.notificationsEnabled);
    _box.write('theme_mode', settings.themeMode.index);
  }
}
