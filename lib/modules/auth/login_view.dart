import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/glass_widgets.dart';
import '../../core/widgets/app_button.dart';
import 'auth_controller.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

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
              key: controller.loginFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('login'.tr, style: Get.textTheme.displaySmall),
                  const SizedBox(height: 12),
                  Text('login_subtitle'.tr, style: Get.textTheme.bodyLarge),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: controller.emailController,
                    decoration: InputDecoration(labelText: 'email'.tr),
                    validator: controller.validateEmail,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: controller.passwordController,
                    decoration: InputDecoration(labelText: 'password'.tr),
                    validator: controller.validatePassword,
                    obscureText: true,
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: controller.loginWithPhone,
                      child: Text('sign_in_phone'.tr),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Obx(
                    () => AppButton(
                      label: controller.isLoading.value
                          ? 'loading'.tr
                          : 'sign_in'.tr,
                      onPressed: controller.isLoading.value
                          ? null
                          : controller.login,
                      expanded: true,
                      icon: Icons.lock_open_rounded,
                    ),
                  ),
                  const SizedBox(height: 12),
                  AppButton(
                    label: 'sign_in_google'.tr,
                    onPressed: controller.loginWithGoogle,
                    expanded: true,
                    icon: Icons.g_mobiledata,
                    isOutlined: true,
                  ),
                  const SizedBox(height: 12),
                  AppButton(
                    label: 'sign_in_apple'.tr,
                    onPressed: controller.loginWithApple,
                    expanded: true,
                    icon: Icons.apple,
                    isOutlined: true,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('no_account'.tr),
                      TextButton(
                        onPressed: controller.goToSignup,
                        child: Text('signup'.tr),
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
