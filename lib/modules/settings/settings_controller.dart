import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/models/app_settings.dart';
import '../../data/repositories/settings_repository.dart';

class SettingsController extends GetxController {
  SettingsRepository get _repository => Get.find<SettingsRepository>();

  late final Rx<AppSettings> settings;

  @override
  void onInit() {
    super.onInit();
    settings = _repository.load().obs;
  }

  void updateLocale(String code) {
    settings.value = settings.value.copyWith(localeCode: code);
    Get.updateLocale(Locale(code));
  }

  void updateDistance(double value) {
    settings.value = settings.value.copyWith(distanceFilterKm: value);
  }

  void toggleNotifications(bool enabled) {
    settings.value = settings.value.copyWith(notificationsEnabled: enabled);
  }

  void toggleDarkMode(bool enabled) {
    settings.value = settings.value
        .copyWith(themeMode: enabled ? ThemeMode.dark : ThemeMode.light);
  }

  void save() {
    _repository.save(settings.value);
  }
}
