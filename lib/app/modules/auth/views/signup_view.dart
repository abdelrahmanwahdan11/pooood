/*
  هذا الملف يبني واجهة إنشاء الحساب مع التحقق الكامل للحقل وخيارات الرجوع.
  يمكن تطويره لاحقاً لدعم رفع صور الهوية أو اتفاقيات الخدمة.
*/
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_routes.dart';
import '../controllers/auth_controller.dart';

class SignupView extends GetView<AuthController> {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text('auth.signup'.tr)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: controller.signupFormKey,
            child: Column(
              children: [
                Text('auth.signup'.tr, style: theme.textTheme.headlineSmall),
                const SizedBox(height: 16),
                TextFormField(
                  controller: controller.nameController,
                  decoration: InputDecoration(labelText: 'auth.name'.tr, prefixIcon: const Icon(Icons.person_outline)),
                  validator: controller.validateSignupName,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: controller.emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(labelText: 'auth.email'.tr, prefixIcon: const Icon(Icons.email_outlined)),
                  validator: controller.validateSignupEmail,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: controller.phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(labelText: 'auth.phone'.tr, prefixIcon: const Icon(Icons.phone_outlined)),
                  validator: controller.validateSignupPhone,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: controller.passwordController,
                  obscureText: true,
                  decoration: InputDecoration(labelText: 'auth.password'.tr, prefixIcon: const Icon(Icons.lock_outline)),
                  validator: controller.validateSignupPassword,
                ),
                const SizedBox(height: 24),
                Obx(() => ElevatedButton.icon(
                      onPressed: controller.isLoading.value ? null : controller.signup,
                      icon: const Icon(Icons.check_circle_outline),
                      label: controller.isLoading.value
                          ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                          : Text('auth.signup'.tr),
                    )),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : () {
                          Get.offNamed(AppRoutes.login);
                        },
                  child: Text('auth.haveAccount'.tr),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
