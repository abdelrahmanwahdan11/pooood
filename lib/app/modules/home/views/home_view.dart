import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import '../../../core/services/settings_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/layout_helper.dart';
import '../../../routes/app_routes.dart';
import '../../../translations/app_translations.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  LinearGradient _gradient(String id, bool dark) {
    final map = dark ? AppColors.darkGradients : AppColors.lightGradients;
    final colors = map[id] ?? map.values.first;
    return LinearGradient(colors: colors, begin: Alignment.topLeft, end: Alignment.bottomRight);
  }

  @override
  Widget build(BuildContext context) {
    final settings = Get.find<SettingsService>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text('app_title'.tr),
        actions: [
          IconButton(
            icon: Icon(settings.themeMode == ThemeMode.dark
                ? Icons.dark_mode
                : settings.themeMode == ThemeMode.light
                    ? Icons.light_mode
                    : Icons.brightness_auto),
            onPressed: () {
              final next = settings.themeMode == ThemeMode.light
                  ? ThemeMode.dark
                  : settings.themeMode == ThemeMode.dark
                      ? ThemeMode.system
                      : ThemeMode.light;
              settings.updateTheme(next).then((_) {
                Get.snackbar('theme'.tr, 'snackbar_theme'.tr, snackPosition: SnackPosition.BOTTOM);
              });
            },
          ),
          PopupMenuButton<Locale>(
            icon: const Icon(Icons.language),
            onSelected: (locale) {
              settings.updateLocale(locale).then((_) {
                Get.updateLocale(locale);
                Get.snackbar('language'.tr, 'snackbar_language'.tr, snackPosition: SnackPosition.BOTTOM);
              });
            },
            itemBuilder: (context) => AppTranslations.supportedLocales
                .map(
                  (locale) => PopupMenuItem(
                    value: locale,
                    child: Text(locale.languageCode.toUpperCase()),
                  ),
                )
                .toList(),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 16),
          children: [
            ListTile(
              leading: const CircleAvatar(child: Icon(Icons.person)),
              title: Text('profile_title'.tr),
              subtitle: const Text('hello@mindmirror.app'),
              onTap: () => Get.toNamed(AppRoutes.profile),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.settings),
              title: Text('settings'.tr),
              onTap: () => Get.toNamed(AppRoutes.settings),
            ),
            ListTile(
              leading: const Icon(Icons.share),
              title: Text('invite_title'.tr),
              onTap: () => Get.toNamed(AppRoutes.invite),
            ),
          ],
        ),
      ),
      body: LayoutHelper.constrain(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'home_quiz'.tr,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.separated(
                  itemCount: controller.cards.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final card = controller.cards[index];
                    final icon = [Icons.psychology, Icons.chat_bubble_rounded, Icons.people_alt][index];
                    return GestureDetector(
                      onTap: () => controller.open(card.route),
                      child: Container(
                        height: 160,
                        decoration: BoxDecoration(
                          gradient: _gradient(card.gradientId, isDark),
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 28,
                              offset: const Offset(0, 18),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(24),
                        child: Row(
                          children: [
                            Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Icon(icon, color: Colors.white, size: 32),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    card.titleKey.tr,
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    card.descriptionKey.tr,
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          color: Colors.white.withOpacity(0.8),
                                        ),
                                  ),
                                ],
                              ).animate().fadeIn(duration: 400.ms, delay: (index * 120).ms).move(begin: const Offset(0, 12)),
                            ),
                            const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white),
                          ],
                        ),
                      ).animate().fadeIn(duration: 450.ms, delay: (index * 120).ms).move(begin: const Offset(0, 20)),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
