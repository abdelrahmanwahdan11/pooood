import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/utils/layout_helper.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text('profile_title'.tr)),
      body: LayoutHelper.constrain(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              CircleAvatar(
                radius: 48,
                backgroundColor: theme.colorScheme.primary.withOpacity(0.2),
                child: Icon(Icons.person, size: 48, color: theme.colorScheme.primary),
              ),
              const SizedBox(height: 16),
              Obx(
                () => Text(
                  controller.displayName.value,
                  style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              Obx(
                () => Text(
                  controller.email.value,
                  style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor),
                ),
              ),
              const SizedBox(height: 24),
              FilledButton.tonal(
                onPressed: () {},
                child: Text('profile_edit'.tr),
              ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () => Get.back(),
                child: Text('profile_logout'.tr),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
