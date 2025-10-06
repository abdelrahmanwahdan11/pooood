/*
  هذا الملف يبني واجهة تسجيل الدخول مع نماذج التحقق وخيارات الضيف والتبديل للغة.
  يمكن تطويره لإضافة تسجيل اجتماعي أو مصادقة متعددة العوامل لاحقاً.
*/
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_routes.dart';
import '../controllers/auth_controller.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    final locale = Get.locale?.languageCode == 'ar'
                        ? const Locale('en', 'US')
                        : const Locale('ar', 'SA');
                    Get.updateLocale(locale);
                  },
                  child: Text(Get.locale?.languageCode == 'ar' ? 'English' : 'العربية'),
                ),
              ),
              Text('app.title'.tr, style: theme.textTheme.headlineMedium),
              const SizedBox(height: 12),
              Text('auth.login'.tr, style: theme.textTheme.titleLarge),
              const SizedBox(height: 24),
              Form(
                key: controller.loginFormKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: controller.loginEmailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(labelText: 'auth.email'.tr, prefixIcon: const Icon(Icons.email_outlined)),
                      validator: controller.validateLoginEmail,
                    ),
                    const SizedBox(height: 16),
                    Obx(() {
                      return TextFormField(
                        controller: controller.loginPasswordController,
                        obscureText: true,
                        decoration: InputDecoration(labelText: 'auth.password'.tr, prefixIcon: const Icon(Icons.lock_outline)),
                        validator: controller.validateLoginPassword,
                      );
                    }),
                    const SizedBox(height: 16),
                    Obx(() => CheckboxListTile(
                          value: controller.rememberMe.value,
                          onChanged: (value) => controller.rememberMe.value = value ?? true,
                          title: Text('auth.remember'.tr),
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.zero,
                        )),
                    const SizedBox(height: 24),
                    Obx(() => ElevatedButton.icon(
                          onPressed: controller.isLoading.value ? null : controller.login,
                          icon: const Icon(Icons.login),
                          label: controller.isLoading.value
                              ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                              : Text('auth.login'.tr),
                        )),
                    const SizedBox(height: 12),
                    OutlinedButton(
                      onPressed: controller.isLoading.value
                          ? null
                          : () {
                              Get.toNamed(AppRoutes.signup);
                            },
                      child: Text('auth.noAccount'.tr),
                    ),
                    const SizedBox(height: 12),
                    TextButton.icon(
                      onPressed: controller.isLoading.value ? null : controller.guestLogin,
                      icon: const Icon(Icons.person_outline),
                      label: Text('auth.guest'.tr),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
