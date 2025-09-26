import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/routing/app_routes.dart';
import '../../data/repositories/settings_repo.dart';

class ShellController extends GetxController {
  ShellController(this.settingsRepository);

  final SettingsRepository settingsRepository;

  final pageIndex = 0.obs;
  final searchQuery = ''.obs;
  final PageController pageController = PageController();
  final TextEditingController searchController = TextEditingController();
  Timer? _debounce;

  @override
  void onClose() {
    pageController.dispose();
    searchController.dispose();
    _debounce?.cancel();
    super.onClose();
  }

  void onTabSelected(int index) {
    pageIndex.value = index;
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
    );
  }

  void onPageChanged(int index) {
    pageIndex.value = index;
  }

  void onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 280), () {
      searchQuery.value = query.trim();
    });
  }

  void openNotifications() {
    Get.toNamed(AppRoutes.notifications);
  }

  void openAddFlow() {
    Get.toNamed(AppRoutes.addItem);
  }

  void openMyActivity() {
    Get.toNamed(AppRoutes.myActivity);
  }

  void openSettingsDrawer(GlobalKey<ScaffoldState> scaffoldKey) {
    scaffoldKey.currentState?.openEndDrawer();
  }
}
