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

  @override
  AppSettings load() {
    final locale = _box.read<String>('locale') ?? 'ar';
    final distance = _box.read<double>('distance_filter') ?? 10;
    final notifications = _box.read<bool>('notifications') ?? true;
    final themeModeIndex = _box.read<int>('theme_mode') ?? ThemeMode.light.index;
    return AppSettings(
      localeCode: locale,
      distanceFilterKm: distance,
      notificationsEnabled: notifications,
      themeMode: ThemeMode.values[themeModeIndex],
    );
  }

  @override
  void save(AppSettings settings) {
    _box.write('locale', settings.localeCode);
    _box.write('distance_filter', settings.distanceFilterKm);
    _box.write('notifications', settings.notificationsEnabled);
    _box.write('theme_mode', settings.themeMode.index);
  }
}
