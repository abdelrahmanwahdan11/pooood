import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/widgets/gradient_card.dart';
import 'settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        GradientCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'settings'.tr,
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              Text(
                'language'.tr,
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Obx(
                () => Wrap(
                  spacing: 12,
                  children: [
                    _LocaleChip(
                      label: 'English',
                      code: 'en',
                      selected: controller.locale.value.languageCode == 'en',
                      onSelected: controller.changeLocale,
                    ),
                    _LocaleChip(
                      label: 'العربية',
                      code: 'ar',
                      selected: controller.locale.value.languageCode == 'ar',
                      onSelected: controller.changeLocale,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Obx(
                () => SwitchListTile.adaptive(
                  value: controller.darkMode.value,
                  title: Text('dark_mode'.tr),
                  onChanged: controller.toggleDarkMode,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        GradientCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'notifications'.tr,
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              Text(
                'instagram_hint'.tr,
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: controller.sendMockNotification,
                icon: const Icon(Icons.notifications_active),
                label: Text('send_mock_notification'.tr),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LocaleChip extends StatelessWidget {
  const _LocaleChip({
    required this.label,
    required this.code,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final String code;
  final bool selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onSelected(code),
    );
  }
}
