import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/services/settings_service.dart';
import '../../../routes/app_routes.dart';

class OnboardingController extends GetxController {
  final pageController = PageController();
  final currentIndex = 0.obs;

  final slides = [
    (
      titleKey: 'onboarding_title_1',
      descriptionKey: 'onboarding_desc_1',
      gradientId: 'quiz_card',
    ),
    (
      titleKey: 'onboarding_title_2',
      descriptionKey: 'onboarding_desc_2',
      gradientId: 'insights_card',
    ),
    (
      titleKey: 'onboarding_title_3',
      descriptionKey: 'onboarding_desc_3',
      gradientId: 'compare_card',
    ),
  ];

  void onPageChanged(int index) {
    currentIndex.value = index;
  }

  Future<void> complete() async {
    await Get.find<SettingsService>().setOnboardingComplete();
    Get.offAllNamed(AppRoutes.home);
  }
}
