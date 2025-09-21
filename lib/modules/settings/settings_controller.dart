import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/datasources/local/get_storage_ds.dart';
import '../../services/notification_service.dart';

class SettingsController extends GetxController {
  SettingsController(this._local, this._notifications);

  final GetStorageDataSource _local;
  final NotificationService _notifications;

  late final Rx<Locale> locale;
  late final RxBool darkMode;

  @override
  void onInit() {
    super.onInit();
    locale = (Get.locale ?? const Locale('en')).obs;
    final stored = _local.readLocale();
    if (stored != null) {
      locale.value = Locale(stored);
    }
    darkMode = _local.isDarkMode.obs;
  }

  Future<void> changeLocale(String code) async {
    final newLocale = Locale(code);
    locale.value = newLocale;
    await _local.writeLocale(code);
    Get.updateLocale(newLocale);
  }

  Future<void> toggleDarkMode(bool value) async {
    darkMode.value = value;
    await _local.setDarkMode(value);
    Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);
  }

  Future<void> sendMockNotification() async {
    await _notifications.showLocalMockNotification(
      title: 'Green Auction',
      body: 'Your watched item is heating up!',
    );
  }
}
