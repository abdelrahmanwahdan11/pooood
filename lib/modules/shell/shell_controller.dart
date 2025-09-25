import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/routing/app_routes.dart';
import '../../data/models/user.dart';
import '../../data/repositories/user_repository.dart';
import '../../services/notifications_service.dart';

class ShellController extends GetxController {
  final currentIndex = 0.obs;
  final searchQuery = ''.obs;

  late final User user;

  NotificationsService get notificationsService => Get.find<NotificationsService>();

  @override
  void onInit() {
    super.onInit();
    user = Get.find<UserRepository>().currentUser;
  }

  void changeTab(int index) {
    currentIndex.value = index;
  }

  void updateSearch(String value) {
    searchQuery.value = value;
  }

  void openFilters() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('filters'.tr, style: Get.textTheme.titleLarge),
            const SizedBox(height: 12),
            Text('search_filters_hint'.tr),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: Get.back,
                child: Text('apply_filters'.tr),
              ),
            )
          ],
        ),
      ),
    );
  }

  void openNotifications() {
    Get.toNamed(AppRoutes.notifications);
  }

  void openAddItem() {
    Get.toNamed(AppRoutes.addItem);
  }

  void openMyActivity(String tab) {
    Get.toNamed(AppRoutes.myActivity, arguments: tab);
  }
}
