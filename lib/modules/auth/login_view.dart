import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/widgets/app_button.dart';
import '../../core/widgets/glass_container.dart';
import 'auth_controller.dart';
import 'signup_view.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Directionality(
      textDirection: Get.locale?.languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        extendBody: true,
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF111A2E), Color(0xFF1F2A44)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('welcome_back'.tr, style: theme.textTheme.headlineMedium?.copyWith(color: Colors.white)),
                  const SizedBox(height: 8),
                  Text('login_subtitle'.tr, style: theme.textTheme.bodyLarge?.copyWith(color: Colors.white70)),
                  const SizedBox(height: 32),
                  GlassContainer(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        TextField(
                          controller: controller.loginEmailController,
                          decoration: InputDecoration(
                            labelText: 'email'.tr,
                            prefixIcon: const Icon(Icons.alternate_email),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: controller.loginPasswordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'password'.tr,
                            prefixIcon: const Icon(Icons.lock_outline),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Obx(
                          () => AppButton(
                            label: controller.isLoginLoading.value ? '...' : 'login'.tr,
                            onPressed: controller.isLoginLoading.value ? null : controller.login,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('dont_have_account'.tr, style: const TextStyle(color: Colors.white70)),
                      TextButton(
                        onPressed: () => Get.to(() => const SignupView()),
                        child: Text('signup'.tr),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // TODO: Firebase
                  // 1) أزرار تسجيل الدخول عبر Google / Apple / Phone.
                  // 2) تنفيذ مصادقة متعددة العوامل وتخزين tokens.
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
