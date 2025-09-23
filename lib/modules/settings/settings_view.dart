import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/widgets/app_button.dart';
import 'settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('settings'.tr)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('settings_description'.tr, style: Get.textTheme.bodyLarge),
            const SizedBox(height: 16),
            Obx(
              () => SwitchListTile(
                value: controller.notificationsEnabled.value,
                onChanged: controller.toggleNotifications,
                title: Text('enable_notifications'.tr),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.location_on_outlined),
              title: Text('enable_location'.tr),
              subtitle: Text('map_description'.tr),
              onTap: controller.requestLocation,
            ),
            Obx(
              () => SwitchListTile(
                value: controller.isDarkMode.value,
                onChanged: controller.switchTheme,
                title: Text('dark_mode'.tr),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.language),
              title: Text('change_language'.tr),
              onTap: () => _showLanguageDialog(context),
            ),
            const Spacer(),
            AppButton(
              label: 'logout'.tr,
              onPressed: controller.logout,
              expanded: true,
              icon: Icons.logout,
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: Text('language'.tr),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('arabic'.tr),
              onTap: () {
                controller.changeLanguage(const Locale('ar'));
                Get.back();
              },
            ),
            ListTile(
              title: Text('english'.tr),
              onTap: () {
                controller.changeLanguage(const Locale('en'));
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }
}
