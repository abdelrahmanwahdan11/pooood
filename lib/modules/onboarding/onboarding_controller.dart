import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/routing/app_routes.dart';
import '../../data/repositories/settings_repo.dart';
import '../../data/repositories/watch_store_repo.dart';

class OnboardingController extends GetxController {
  OnboardingController(this.settingsRepository, this.watchStoreRepository);

  final SettingsRepository settingsRepository;
  final WatchStoreRepository watchStoreRepository;

  final pageController = PageController();
  final currentPage = 0.obs;
  late final List<String> slides;

  @override
  void onInit() {
    slides = watchStoreRepository.onboardingKeys();
    super.onInit();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  void onPageChanged(int index) {
    currentPage.value = index;
  }

  Future<void> next() async {
    if (currentPage.value >= slides.length - 1) {
      await complete();
      return;
    }
    pageController.nextPage(
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutQuart,
    );
  }

  Future<void> skip() async {
    await complete();
  }

  Future<void> complete() async {
    await settingsRepository.completeOnboarding();
    if (settingsRepository.authToken != null || settingsRepository.isGuestMode) {
      Get.offAllNamed(AppRoutes.shell);
    } else {
      Get.offAllNamed(AppRoutes.auth);
    }
  }
}
