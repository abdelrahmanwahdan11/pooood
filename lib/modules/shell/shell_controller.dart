import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/repositories/settings_repo.dart';

class ShellController extends GetxController {
  ShellController(this.settingsRepository);

  final SettingsRepository settingsRepository;

  final RxInt pageIndex = RxInt(0);
  final PageController pageController = PageController();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  void onTabSelected(int index) {
    pageIndex.value = index;
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
    );
  }

  void onPageChanged(int index) {
    pageIndex.value = index;
  }

  Future<void> toggleLocale() async {
    final current = settingsRepository.currentLocale.languageCode;
    final locale = current == 'ar' ? const Locale('en') : const Locale('ar');
    await settingsRepository.updateLocale(locale);
    Get.updateLocale(locale);
  }
}
