import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import '../../../core/services/settings_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/layout_helper.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  LinearGradient _gradient(String id, bool dark) {
    final map = dark ? AppColors.darkGradients : AppColors.lightGradients;
    final colors = map[id] ?? map.values.first;
    return LinearGradient(colors: colors, begin: Alignment.topLeft, end: Alignment.bottomRight);
  }

  IconData _iconFor(String name) {
    switch (name) {
      case 'chat':
        return Icons.chat_bubble_outline;
      case 'groups':
        return Icons.people_alt_outlined;
      default:
        return Icons.psychology_alt_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = Get.find<SettingsService>();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final reducedMotion = controller.reducedMotion;
    return Scaffold(
      body: SafeArea(
        child: LayoutHelper.constrain(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('app_title'.tr, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                    const Spacer(),
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
                    IconButton(
                      icon: const Icon(Icons.settings_outlined),
                      onPressed: controller.openSettings,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Obx(
                  () => Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          theme.colorScheme.primary.withOpacity(0.12),
                          theme.colorScheme.secondary.withOpacity(0.18),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surface.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(controller.greeting(), style: theme.textTheme.labelMedium),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          controller.displayName.value,
                          style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 8),
                        Text('home_tagline'.tr, style: theme.textTheme.bodyLarge?.copyWith(color: theme.hintColor)),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Icon(Icons.local_fire_department, color: theme.colorScheme.secondary),
                            const SizedBox(width: 8),
                            Obx(
                              () => Text(
                                'home_streak'.trParams({'count': controller.streak.value.toString()}),
                                style: theme.textTheme.labelLarge,
                              ),
                            ),
                            const Spacer(),
                            TextButton.icon(
                              onPressed: controller.celebrateReflection,
                              icon: const Icon(Icons.check_circle_outline),
                              label: Text('feature_daily_reflection_title'.tr),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                if (controller.highlightFeatures().isNotEmpty) ...[
                  Text('features_spotlight'.tr, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: controller.highlightFeatures()
                        .map(
                          (feature) => ActionChip(
                            label: Text(feature.titleKey.tr),
                            avatar: Icon(feature.icon, size: 18),
                            onPressed: controller.openFeatures,
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 24),
                ],
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var i = 0; i < controller.cards.length; i++)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: GestureDetector(
                          onTap: () => controller.open(controller.cards[i].route as String),
                          child: Container(
                            height: 160,
                            decoration: BoxDecoration(
                              gradient: _gradient(controller.cards[i].gradientId as String, isDark),
                              borderRadius: BorderRadius.circular(32),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 26,
                                  offset: const Offset(0, 18),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(24),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 60,
                                  width: 60,
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.surface.withOpacity(0.6),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Icon(_iconFor(controller.cards[i].icon as String), color: theme.colorScheme.onPrimaryContainer),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        (controller.cards[i].titleKey as String).tr,
                                        style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        (controller.cards[i].descriptionKey as String).tr,
                                        style: theme.textTheme.bodyMedium,
                                      ),
                                    ],
                                  ).animate(target: reducedMotion ? 0 : 1).fadeIn(duration: 400.ms, delay: (i * 120).ms).move(begin: Offset(0, reducedMotion ? 0 : 12)),
                                ),
                                const Icon(Icons.arrow_forward_ios_rounded),
                              ],
                            ),
                          ).animate(target: reducedMotion ? 0 : 1).fadeIn(duration: 450.ms, delay: (i * 120).ms).move(begin: Offset(0, reducedMotion ? 0 : 20)),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                FilledButton.tonalIcon(
                  onPressed: controller.openFeatures,
                  icon: const Icon(Icons.star_outline),
                  label: Text('features_manage_cta'.tr),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
