import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../main.dart';
import '../auth/auth_routes.dart';

class OnboardingController extends GetxController {
  final PageController pageController = PageController();
  final RxInt pageIndex = 0.obs;

  final slides = const [
    'onboard_connect',
    'onboard_trade',
    'onboard_chat',
  ];

  AppController get appController => Get.find<AppController>();

  void onPageChanged(int index) => pageIndex.value = index;

  void skip() => finish();

  void next() {
    if (pageIndex.value == slides.length - 1) {
      finish();
    } else {
      pageController.nextPage(duration: const Duration(milliseconds: 320), curve: Curves.easeOut);
    }
  }

  Future<void> finish() async {
    await appController.completeOnboarding();
    Get.offAllNamed(appController.initialRoute);
  }

  void goToAuth() => Get.offAllNamed(AuthRoutes.route);
}
