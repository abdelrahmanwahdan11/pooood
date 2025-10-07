import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/services/settings_service.dart';
import '../../../core/utils/layout_helper.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  void _openEditSheet(BuildContext context) {
    final nameController = TextEditingController(text: controller.displayName.value);
    final emailController = TextEditingController(text: controller.email.value);
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (context) {
        final viewInsets = MediaQuery.of(context).viewInsets.bottom;
        return Padding(
          padding: EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 24 + viewInsets),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('profile_edit'.tr, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'auth_name'.tr),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'auth_email'.tr),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () async {
                    await controller.updateProfile(
                      name: nameController.text,
                      email: emailController.text,
                    );
                    Get.back();
                    Get.snackbar('profile_title'.tr, 'snackbar_saved'.tr, snackPosition: SnackPosition.BOTTOM);
                  },
                  child: Text('save_exit'.tr),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final settings = Get.find<SettingsService>();
    return Scaffold(
      appBar: AppBar(title: Text('profile_title'.tr)),
      body: LayoutHelper.constrain(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 48,
                backgroundColor: theme.colorScheme.primary.withOpacity(0.15),
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
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: theme.colorScheme.secondaryContainer.withOpacity(theme.brightness == Brightness.dark ? 0.2 : 0.4),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Row(
                  children: [
                    Icon(Icons.local_fire_department, color: theme.colorScheme.secondary),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Obx(
                        () {
                          final streak = settings.streakRx.value;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('feature_streak_tracker_title'.tr, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                              const SizedBox(height: 4),
                              Text('feature_streak_tracker_desc'.trParams({'count': streak.toString()})),
                            ],
                          );
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      tooltip: 'feature_data_control_title'.tr,
                      onPressed: () => settings.registerReflection(reset: true),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              FilledButton.tonal(
                onPressed: () => _openEditSheet(context),
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
