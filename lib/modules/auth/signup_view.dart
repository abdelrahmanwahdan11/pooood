import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/widgets/app_button.dart';
import '../../core/widgets/glass_container.dart';
import 'auth_controller.dart';

class SignupView extends GetView<AuthController> {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Directionality(
      textDirection: Get.locale?.languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text('signup'.tr),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0F172A), Color(0xFF243B55)],
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
                  Text('signup_subtitle'.tr, style: theme.textTheme.bodyLarge?.copyWith(color: Colors.white70)),
                  const SizedBox(height: 24),
                  GlassContainer(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        TextField(
                          controller: controller.signupEmailController,
                          decoration: InputDecoration(
                            labelText: 'email'.tr,
                            prefixIcon: const Icon(Icons.email_outlined),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: controller.signupPasswordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'password'.tr,
                            prefixIcon: const Icon(Icons.lock_outline),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Obx(
                          () => AppButton(
                            label: controller.isSignupLoading.value ? '...' : 'signup'.tr,
                            onPressed: controller.isSignupLoading.value ? null : controller.signup,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: TextButton(
                      onPressed: () => Get.back(),
                      child: Text('already_have_account'.tr),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // TODO: Firebase
                  // 1) تفعيل تسجيل الهاتف عبر FirebaseAuth.verifyPhoneNumber.
                  // 2) حفظ بيانات المستخدم داخل Firestore collection `users` مع الحقول المفضلة.
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
