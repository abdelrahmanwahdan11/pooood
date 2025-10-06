/*
  هذا الملف يبني واجهة شاشة البداية مع مؤثرات تحريكية بسيطة وعرض التقدم.
  يمكن تطويره لإضافة شاشات ترحيبية متعددة أو فيديو افتتاحي.
*/
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [theme.colorScheme.primary, theme.colorScheme.secondary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.gavel, size: 96, color: theme.colorScheme.onPrimary).animate().scale(duration: 600.ms),
            const SizedBox(height: 24),
            Text('splash.welcome'.tr,
                style: theme.textTheme.headlineSmall?.copyWith(color: theme.colorScheme.onPrimary)),
            const SizedBox(height: 12),
            Obx(() => Text('splash.loading'.tr,
                style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onPrimary))),
            const SizedBox(height: 36),
            Obx(() {
              return CircularProgressIndicator(
                value: controller.progress.value >= 1 ? null : controller.progress.value,
                valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.onPrimary),
                backgroundColor: theme.colorScheme.onPrimary.withOpacity(0.3),
              ).animate().fadeIn(duration: 500.ms);
            }),
          ],
        ),
      ),
    );
  }
}
