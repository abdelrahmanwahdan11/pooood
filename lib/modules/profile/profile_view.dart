import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/routing/app_routes.dart';
import '../../core/widgets/glass_container.dart';
import 'profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: Get.locale?.languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text('profile'.tr),
        ),
        body: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            GlassContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Trend Electronics', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text('status_online'.tr),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => Get.toNamed(AppRoutes.settings),
                    child: Text('settings'.tr),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
