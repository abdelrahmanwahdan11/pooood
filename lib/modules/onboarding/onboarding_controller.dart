import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/routing/app_routes.dart';
import '../../data/datasources/local/get_storage_ds.dart';

class OnboardingController extends GetxController {
  OnboardingController(this._storage);

  final GetStorageDataSource _storage;
  final pageController = PageController();
  final currentPage = 0.obs;

  void onPageChanged(int index) {
    currentPage.value = index;
  }

  void skip() {
    _complete();
  }

  void next() {
    if (currentPage.value < 2) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeOutQuad,
      );
    } else {
      _complete();
    }
  }

  Future<void> _complete() async {
    await _storage.write('onboarding_complete', true);
    Get.offAllNamed(AppRoutes.login);
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
