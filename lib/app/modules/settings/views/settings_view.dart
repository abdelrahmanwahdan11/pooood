/*
  هذا الملف يبني واجهة الإعدادات مع خيارات اللغة والثيم والتنبيهات المحاكية.
  يمكن تطويره لإضافة صفحات فرعية أو دمج خدمات خارجية لاحقاً.
*/
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import '../../../routes/app_routes.dart';
import '../controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('settings.title'.tr)),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 3,
        onTap: (index) {
          switch (index) {
            case 0:
              Get.offAllNamed(AppRoutes.home);
              break;
            case 1:
              Get.toNamed(AppRoutes.wishlist);
              break;
            case 2:
              Get.toNamed(AppRoutes.myBids);
              break;
            default:
              break;
          }
        },
        items: [
          BottomNavigationBarItem(icon: const Icon(Icons.home), label: 'nav.home'.tr),
          BottomNavigationBarItem(icon: const Icon(Icons.favorite), label: 'nav.wishlist'.tr),
          BottomNavigationBarItem(icon: const Icon(Icons.local_offer), label: 'nav.mybids'.tr),
          BottomNavigationBarItem(icon: const Icon(Icons.settings), label: 'nav.settings'.tr),
        ],
      ),
      body: Obx(() => ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text('settings.language'.tr, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Wrap(
                spacing: 12,
                children: [
                  ChoiceChip(
                    label: const Text('العربية'),
                    selected: Get.locale?.languageCode == 'ar',
                    onSelected: (value) => controller.changeLanguage(const Locale('ar', 'SA')),
                  ),
                  ChoiceChip(
                    label: const Text('English'),
                    selected: Get.locale?.languageCode == 'en',
                    onSelected: (value) => controller.changeLanguage(const Locale('en', 'US')),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text('settings.theme'.tr, style: Theme.of(context).textTheme.titleMedium),
              RadioListTile<ThemeMode>(
                value: ThemeMode.system,
                groupValue: controller.themeMode.value,
                onChanged: (value) {
                  if (value != null) controller.setTheme(value);
                },
                title: Text('settings.systemMode'.tr),
              ),
              RadioListTile<ThemeMode>(
                value: ThemeMode.light,
                groupValue: controller.themeMode.value,
                onChanged: (value) {
                  if (value != null) controller.setTheme(value);
                },
                title: Text('settings.lightMode'.tr),
              ),
              RadioListTile<ThemeMode>(
                value: ThemeMode.dark,
                groupValue: controller.themeMode.value,
                onChanged: (value) {
                  if (value != null) controller.setTheme(value);
                },
                title: Text('settings.darkMode'.tr),
              ),
              const SizedBox(height: 24),
              SwitchListTile(
                value: controller.notificationsEnabled.value,
                onChanged: controller.toggleNotifications,
                title: Text('settings.notifications'.tr),
                subtitle: Text('notifications.placeholder'.tr),
              ),
              SwitchListTile(
                value: controller.isOffline.value,
                onChanged: controller.toggleOffline,
                title: Text('settings.offline'.tr),
                subtitle: Text('offline.placeholder'.tr),
              ),
              const SizedBox(height: 24),
              ExpansionTile(
                title: Text('settings.about'.tr),
                children: [
                  ListTile(
                    title: Text('settings.version'.tr),
                    subtitle: Text('app.title'.tr),
                  ),
                  ListTile(
                    title: Text('settings.tutorial'.tr),
                    subtitle: Text('tutorial.step1'.tr),
                  ),
                  ListTile(
                    title: Text('settings.quickActions'.tr),
                    subtitle: Text('coach.start'.tr),
                  ),
                ],
              ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.2, end: 0),
            ],
          )),
    );
  }
}
