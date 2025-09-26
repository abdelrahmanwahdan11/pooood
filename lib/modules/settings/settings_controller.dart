import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/app_theme.dart';
import '../../data/models/user.dart';
import '../../data/repositories/settings_repo.dart';

class SettingsController extends GetxController {
  SettingsController(this.repository);

  final SettingsRepository repository;

  final user = Rxn<User>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final locationController = TextEditingController();
  final paymentController = TextEditingController();
  final avatarController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final u = await repository.fetchUser();
    user.value = u;
    nameController.text = u.name;
    emailController.text = u.email;
    phoneController.text = u.phone;
    locationController.text = u.defaultLocation;
    paymentController.text = u.paymentMethod;
    avatarController.text = u.avatarUrl;
  }

  Future<void> saveProfile() async {
    final current = user.value;
    if (current == null) return;
    final updated = current.copyWith(
      name: nameController.text,
      email: emailController.text,
      phone: phoneController.text,
      defaultLocation: locationController.text,
      paymentMethod: paymentController.text,
      avatarUrl: avatarController.text,
    );
    await repository.saveUser(updated);
    user.value = updated;
    Get.snackbar('app_name'.tr, 'snackbar_saved'.tr,
        snackPosition: SnackPosition.BOTTOM);
  }

  Future<void> changeLanguage(Locale locale) async {
    await repository.updateLocale(locale);
    Get.updateLocale(locale);
  }

  Future<void> changeThemeDensity(ThemeDensity density) async {
    await repository.updateThemeDensity(density);
    Get.changeTheme(AppTheme.buildThemeData(repository));
  }

  Future<void> changeDistanceUnit(DistanceUnit unit) async {
    await repository.updateDistanceUnit(unit);
  }

  Future<void> changeCurrency(String value) async {
    await repository.updateCurrency(value);
  }

  Future<void> toggleNotifications({bool? bids, bool? matches, bool? discounts}) async {
    await repository.updateNotificationSettings(
      bids: bids,
      matches: matches,
      discounts: discounts,
    );
  }

  Future<void> toggleSecurity({bool? pin, bool? biometric}) async {
    await repository.updateSecurity(pin: pin, biometric: biometric);
  }

  Future<void> togglePrivacy(bool visible) async {
    await repository.updatePrivacy(visible: visible);
  }

  Future<String> exportData() async {
    final data = await repository.exportData();
    return jsonEncode(data);
  }

  Future<void> importData(String jsonString) async {
    final data = jsonDecode(jsonString) as Map<String, dynamic>;
    await repository.importData(data);
    await _loadUser();
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    locationController.dispose();
    paymentController.dispose();
    avatarController.dispose();
    super.onClose();
  }
}
