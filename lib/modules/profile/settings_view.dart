import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/widgets/glass_container.dart';
import 'profile_controller.dart';

class SettingsView extends GetView<ProfileController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: Get.locale?.languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text('settings'.tr),
        ),
        body: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            GlassContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('language'.tr, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    children: [
                      ChoiceChip(
                        label: const Text('English'),
                        selected: Get.locale?.languageCode == 'en',
                        onSelected: (_) => controller.changeLocale('en'),
                      ),
                      ChoiceChip(
                        label: const Text('العربية'),
                        selected: Get.locale?.languageCode == 'ar',
                        onSelected: (_) => controller.changeLocale('ar'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            GlassContainer(
              child: Obx(
                () => SwitchListTile(
                  title: Text('enable_notifications'.tr),
                  value: controller.isNotificationsEnabled.value,
                  onChanged: controller.toggleNotifications,
                ),
              ),
            ),
            const SizedBox(height: 16),
            GlassContainer(
              child: ListTile(
                title: Text('location'.tr),
                subtitle: Text('update_location'.tr),
                trailing: const Icon(Icons.my_location),
                onTap: controller.updateLocation,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
