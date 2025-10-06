import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/utils/layout_helper.dart';
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
              const SizedBox(height: 24),
              Text('theme'.tr, style: theme.textTheme.titleMedium),
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
              const SizedBox(height: 24),
              Text('language'.tr, style: theme.textTheme.titleMedium),
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
              const SizedBox(height: 32),
              Text('settings_about'.tr, style: theme.textTheme.bodyLarge),
            ],
          ),
        ),
      ),
    );
  }
}
