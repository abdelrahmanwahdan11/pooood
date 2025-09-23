import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/glass_widgets.dart';
import '../../core/widgets/app_button.dart';
import 'language_controller.dart';

class LanguageGateView extends GetView<LanguageController> {
  const LanguageGateView({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassScaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('language_select_title'.tr,
                style: Get.textTheme.displaySmall,
                textAlign: TextAlign.start),
            const SizedBox(height: 12),
            Text('choose_language'.tr,
                style: Get.textTheme.bodyMedium,
                textAlign: TextAlign.start),
            const Spacer(),
            AppButton(
              label: 'arabic'.tr,
              onPressed: () => controller.selectLocale(const Locale('ar')),
              icon: Icons.language,
              expanded: true,
            ),
            const SizedBox(height: 16),
            AppButton(
              label: 'english'.tr,
              onPressed: () => controller.selectLocale(const Locale('en')),
              icon: Icons.language_outlined,
              expanded: true,
            ),
            const SizedBox(height: 16),
            Text(
              'continue_label'.tr,
              textAlign: TextAlign.center,
              style: Get.textTheme.bodySmall?.copyWith(color: Colors.white70),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
