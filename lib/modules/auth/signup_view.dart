import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/glass_widgets.dart';
import '../../core/utils/validators.dart';
import '../../core/widgets/app_button.dart';
import 'auth_controller.dart';

class SignupView extends GetView<AuthController> {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    final isRtl = Get.locale?.languageCode == 'ar';
    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: GlassScaffold(
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Form(
              key: controller.signupFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('signup'.tr, style: Get.textTheme.displaySmall),
                  const SizedBox(height: 12),
                  Text('signup_subtitle'.tr, style: Get.textTheme.bodyLarge),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: controller.fullNameController,
                    decoration: InputDecoration(labelText: 'full_name'.tr),
                    validator: (value) => Validators.notEmpty(value)?.tr,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: controller.emailController,
                    decoration: InputDecoration(labelText: 'email'.tr),
                    validator: controller.validateEmail,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: controller.phoneController,
                    decoration: InputDecoration(labelText: 'phone_number'.tr),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: controller.passwordController,
                    decoration: InputDecoration(labelText: 'password'.tr),
                    obscureText: true,
                    validator: controller.validatePassword,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: controller.confirmPasswordController,
                    decoration: InputDecoration(labelText: 'confirm_password'.tr),
                    obscureText: true,
                  ),
                  const SizedBox(height: 24),
                  Obx(
                    () => AppButton(
                      label: controller.isLoading.value
                          ? 'loading'.tr
                          : 'sign_up'.tr,
                      onPressed: controller.isLoading.value
                          ? null
                          : controller.signup,
                      expanded: true,
                      icon: Icons.person_add_alt_1,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('have_account'.tr),
                      TextButton(
                        onPressed: controller.goToLogin,
                        child: Text('login'.tr),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
