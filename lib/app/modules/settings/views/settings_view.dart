import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/utils/layout_helper.dart';
import '../../../routes/app_routes.dart';
import '../controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text('settings'.tr)),
      body: LayoutHelper.constrain(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('settings_title'.tr, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [theme.colorScheme.primary.withOpacity(0.12), theme.colorScheme.secondary.withOpacity(0.18)],
                  ),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('theme'.tr, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 12),
                    SegmentedButton<ThemeMode>(
                      segments: [
                        ButtonSegment(value: ThemeMode.light, label: Text('light_mode'.tr), icon: const Icon(Icons.light_mode)),
                        ButtonSegment(value: ThemeMode.dark, label: Text('dark_mode'.tr), icon: const Icon(Icons.dark_mode)),
                        ButtonSegment(value: ThemeMode.system, label: Text('system_mode'.tr), icon: const Icon(Icons.brightness_auto)),
                      ],
                      selected: {controller.themeMode},
                      onSelectionChanged: (selection) => controller.changeTheme(selection.first),
                    ),
                    const SizedBox(height: 16),
                    Text('language'.tr, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 12,
                      children: controller.locales
                          .map(
                            (locale) => ChoiceChip(
                              label: Text(locale.languageCode.toUpperCase()),
                              selected: controller.locale.languageCode == locale.languageCode,
                              onSelected: (_) => controller.changeLocale(locale),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text('features_title'.tr, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Obx(
                () => Column(
                  children: [
                    _FeatureTile(
                      title: 'feature_high_contrast_title'.tr,
                      subtitle: 'feature_high_contrast_desc'.tr,
                      value: controller.toggles['high_contrast'] ?? false,
                      onChanged: (value) => controller.toggleFeature('high_contrast', value),
                    ),
                    _FeatureTile(
                      title: 'feature_reduced_motion_title'.tr,
                      subtitle: 'feature_reduced_motion_desc'.tr,
                      value: controller.toggles['reduced_motion'] ?? false,
                      onChanged: (value) => controller.toggleFeature('reduced_motion', value),
                    ),
                    _FeatureTile(
                      title: 'feature_sleep_mode_title'.tr,
                      subtitle: 'feature_sleep_mode_desc'.tr,
                      value: controller.toggles['sleep_mode'] ?? false,
                      onChanged: (value) => controller.toggleFeature('sleep_mode', value),
                    ),
                    _FeatureTile(
                      title: 'feature_haptics_title'.tr,
                      subtitle: 'feature_haptics_desc'.tr,
                      value: controller.toggles['haptics'] ?? false,
                      onChanged: (value) => controller.toggleFeature('haptics', value),
                    ),
                    _FeatureTile(
                      title: 'feature_notification_digest_title'.tr,
                      subtitle: 'feature_notification_digest_desc'.tr,
                      value: controller.toggles['notification_digest'] ?? false,
                      onChanged: (value) => controller.toggleFeature('notification_digest', value),
                    ),
                    _FeatureTile(
                      title: 'feature_data_control_title'.tr,
                      subtitle: 'feature_data_control_desc'.tr,
                      value: controller.toggles['data_control'] ?? false,
                      onChanged: (value) => controller.toggleFeature('data_control', value),
                    ),
                    const SizedBox(height: 12),
                    FilledButton.tonalIcon(
                      onPressed: () => Get.toNamed(AppRoutes.features),
                      icon: const Icon(Icons.extension),
                      label: Text('features_manage_cta'.tr),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text('settings_about'.tr, style: theme.textTheme.bodyLarge),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureTile extends StatelessWidget {
  const _FeatureTile({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 18,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}
