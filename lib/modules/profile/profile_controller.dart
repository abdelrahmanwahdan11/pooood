import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../services/location_service.dart';
import '../../services/notification_service.dart';

class ProfileController extends GetxController {
  ProfileController({
    required this.storage,
    required this.locationService,
    required this.notificationService,
  });

  final GetStorage storage;
  final LocationService locationService;
  final NotificationService notificationService;

  final isNotificationsEnabled = true.obs;

  void changeLocale(String languageCode) {
    Get.updateLocale(Locale(languageCode));
    storage.write('locale', languageCode);
  }

  Future<void> updateLocation() async {
    await locationService.getOrRequestLocation();
    Get.snackbar('location'.tr, 'update_location'.tr);
  }

  void toggleNotifications(bool value) {
    isNotificationsEnabled.value = value;
    // TODO: Firebase
    // 1) ربط مع FCM topic subscription بناءً على قيمة value.
  }
}
