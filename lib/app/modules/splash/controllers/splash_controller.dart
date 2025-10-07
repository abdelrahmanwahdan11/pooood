import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/services/settings_service.dart';
import '../../../routes/app_routes.dart';

class SplashController extends GetxController with GetSingleTickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void onInit() {
    super.onInit();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
  }

  @override
  void onReady() {
    super.onReady();
    Future.delayed(const Duration(milliseconds: 1200), _goNext);
  }

  void _goNext() {
    final settings = Get.find<SettingsService>();
    if (settings.hasCompletedOnboarding) {
      Get.offAllNamed(AppRoutes.home);
    } else {
      Get.offAllNamed(AppRoutes.onboarding);
    }
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}
