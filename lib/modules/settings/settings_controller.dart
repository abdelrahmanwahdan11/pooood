import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/routing/app_routes.dart';
import '../../core/translations/app_translations.dart';
import '../../data/datasources/local/get_storage_ds.dart';
import '../../services/auth_service.dart';
import '../../services/location_service.dart';
import '../../services/notification_service.dart';

class SettingsController extends GetxController {
  SettingsController(
    this._notificationService,
    this._locationService,
    this._authService,
    this._storage,
  );

  final NotificationService _notificationService;
  final LocationService _locationService;
  final AuthService _authService;
  final GetStorageDataSource _storage;

  final notificationsEnabled = false.obs;
  final isDarkMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    isDarkMode.value = Get.isDarkMode;
    notificationsEnabled.value =
        _storage.read<bool>('notifications_enabled') ?? false;
  }

  Future<void> toggleNotifications(bool value) async {
    notificationsEnabled.value = value;
    await _storage.write('notifications_enabled', value);
    if (value) {
      await _notificationService.init();
    }
  }

  Future<void> requestLocation() async {
    await _locationService.determinePosition();
  }

  void switchTheme(bool dark) {
    isDarkMode.value = dark;
    Get.changeThemeMode(dark ? ThemeMode.dark : ThemeMode.light);
  }

  Future<void> changeLanguage(Locale locale) async {
    await AppTranslations.ensureInitialized();
    Get.updateLocale(locale);
    await _storage.write('locale', locale.languageCode);
  }

  Future<void> logout() async {
    await _authService.signOut();
    Get.offAllNamed(AppRoutes.login);
  }
}
