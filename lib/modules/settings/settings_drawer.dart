import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'settings_controller.dart';

class SettingsDrawer extends GetView<SettingsController> {
  const SettingsDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white.withOpacity(0.85),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('settings'.tr,
                    style:
                        Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                Text('language'.tr, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                SegmentedButton<String>(
                  segments: [
                    ButtonSegment(value: 'ar', label: Text('العربية')),
                    ButtonSegment(value: 'en', label: Text('English')),
                  ],
                  selected: {controller.settings.value.localeCode},
                  onSelectionChanged: (value) => controller.updateLocale(value.first),
                ),
                const SizedBox(height: 20),
                SwitchListTile(
                  value: controller.settings.value.notificationsEnabled,
                  title: Text('notifications_toggle'.tr),
                  onChanged: controller.toggleNotifications,
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text('distance_filter'.tr),
                  subtitle: Slider(
                    value: controller.settings.value.distanceFilterKm,
                    min: 1,
                    max: 30,
                    label: controller.settings.value.distanceFilterKm.toStringAsFixed(0),
                    onChanged: controller.updateDistance,
                  ),
                ),
                SwitchListTile(
                  value: controller.settings.value.themeMode == ThemeMode.dark,
                  title: Text('dark_mode'.tr),
                  onChanged: controller.toggleDarkMode,
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      controller.save();
                      Get.back();
                    },
                    child: Text('save'.tr),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
