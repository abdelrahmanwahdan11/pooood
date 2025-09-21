import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/routing/app_routes.dart';
import '../../data/datasources/local/get_storage_ds.dart';

class OnboardingController extends GetxController {
  OnboardingController(this._storage);

  final GetStorageDataSource _storage;

  final PageController pageController = PageController();
  final currentPage = 0.obs;

  void onPageChanged(int index) => currentPage.value = index;

  void skip() => finish();

  void next() {
    if (currentPage.value >= 2) {
      finish();
    } else {
      pageController.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.easeOut);
    }
  }

  void changeLocale(String locale) {
    Get.updateLocale(Locale(locale));
    _storage.locale = locale;
  }

  void finish() {
    _storage.onboardingCompleted = true;
    Get.offAllNamed(AppRoutes.home);
  }
}
