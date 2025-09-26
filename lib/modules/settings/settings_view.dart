import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/utils/responsive.dart';
import '../../core/widgets/glass_container.dart';
import '../../data/repositories/settings_repo.dart';
import 'settings_controller.dart';

class SettingsDrawer extends GetView<SettingsController> {
  const SettingsDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final padding = Responsive.adaptivePadding(context);
    return Drawer(
      backgroundColor: Colors.transparent,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Obx(
            () {
              final user = controller.user.value;
              return ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  if (user != null)
                    GlassContainer(
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 32,
                            backgroundImage: NetworkImage(user.avatarUrl),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(user.name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium),
                                Text(user.email),
                                Text(user.phone),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 24),
                  _sectionTitle(context, 'account'.tr),
                  GlassContainer(
                    child: Column(
                      children: [
                        _textField(controller.nameController, 'name'.tr),
                        _textField(controller.emailController, 'email'.tr),
                        _textField(controller.phoneController, 'phone'.tr),
                        _textField(
                            controller.locationController, 'default_location'.tr),
                        _textField(
                            controller.paymentController, 'payment_method'.tr),
                        _textField(controller.avatarController, 'photos'.tr),
                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerRight,
                          child: FilledButton(
                            onPressed: controller.saveProfile,
                            child: Text('save'.tr),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  _sectionTitle(context, 'app'.tr),
                  GlassContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _settingTile(
                          title: 'language'.tr,
                          trailing: DropdownButton<Locale>(
                            value: controller.repository.currentLocale,
                            onChanged: (value) {
                              if (value != null) controller.changeLanguage(value);
                            },
                            items: const [
                              DropdownMenuItem(
                                value: Locale('ar'),
                                child: Text('العربية'),
                              ),
                              DropdownMenuItem(
                                value: Locale('en'),
                                child: Text('English'),
                              ),
                            ],
                          ),
                        ),
                        _settingTile(
                          title: 'distance_unit'.tr,
                          trailing: DropdownButton<DistanceUnit>(
                            value: controller.repository.distanceUnit,
                            onChanged: (value) {
                              if (value != null) controller.changeDistanceUnit(value);
                            },
                            items: const [
                              DropdownMenuItem(
                                value: DistanceUnit.kilometers,
                                child: Text('km'),
                              ),
                              DropdownMenuItem(
                                value: DistanceUnit.miles,
                                child: Text('mi'),
                              ),
                            ],
                          ),
                        ),
                        _settingTile(
                          title: 'currency'.tr,
                          trailing: DropdownButton<String>(
                            value: controller.repository.currency,
                            onChanged: (value) {
                              if (value != null) controller.changeCurrency(value);
                            },
                            items: const [
                              DropdownMenuItem(value: 'SAR', child: Text('SAR')),
                              DropdownMenuItem(value: 'USD', child: Text('USD')),
                              DropdownMenuItem(value: 'AED', child: Text('AED')),
                            ],
                          ),
                        ),
                        SwitchListTile(
                          title: Text('notifications'.tr),
                          value: controller.repository.notificationsBids,
                          onChanged: (value) =>
                              controller.toggleNotifications(bids: value),
                        ),
                        SwitchListTile(
                          title: Text('receive_alerts'.tr),
                          value: controller.repository.notificationsMatches,
                          onChanged: (value) =>
                              controller.toggleNotifications(matches: value),
                        ),
                        SwitchListTile(
                          title: Text('discounts'.tr),
                          value: controller.repository.notificationsDiscounts,
                          onChanged: (value) =>
                              controller.toggleNotifications(discounts: value),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  _sectionTitle(context, 'security'.tr),
                  GlassContainer(
                    child: Column(
                      children: [
                        SwitchListTile(
                          title: Text('pin_lock'.tr),
                          value: controller.repository.pinEnabled,
                          onChanged: (value) =>
                              controller.toggleSecurity(pin: value),
                        ),
                        SwitchListTile(
                          title: Text('biometric'.tr),
                          value: controller.repository.biometricEnabled,
                          onChanged: (value) =>
                              controller.toggleSecurity(biometric: value),
                        ),
                        SwitchListTile(
                          title: Text('profile_visibility'.tr),
                          value: controller.repository.privacyVisible,
                          onChanged: (value) =>
                              controller.togglePrivacy(value),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  _sectionTitle(context, 'data'.tr),
                  GlassContainer(
                    child: Column(
                      children: [
                        ListTile(
                          title: Text('export_data'.tr),
                          onTap: () async {
                            final json = await controller.exportData();
                            Get.snackbar('export_data'.tr, json,
                                snackPosition: SnackPosition.BOTTOM);
                          },
                        ),
                        ListTile(
                          title: Text('import_data'.tr),
                          onTap: () async {
                            final textController = TextEditingController();
                            final result = await showDialog<String>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('import_data'.tr),
                                content: TextField(
                                  controller: textController,
                                  maxLines: 5,
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () => Get.back(),
                                      child: Text('cancel'.tr)),
                                  FilledButton(
                                    onPressed: () =>
                                        Get.back(result: textController.text),
                                    child: Text('confirm'.tr),
                                  ),
                                ],
                              ),
                            );
                            if (result != null && result.isNotEmpty) {
                              await controller.importData(result);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _textField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(labelText: label),
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String label) {
    return Text(label, style: Theme.of(context).textTheme.titleLarge);
  }

  Widget _settingTile({required String title, Widget? trailing}) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title),
      trailing: trailing,
    );
  }
}
