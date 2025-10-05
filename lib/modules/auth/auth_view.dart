import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/widgets/hard_shadow_box.dart';
import '../../main.dart';
import '../home/home_routes.dart';
import '../onboarding/onboarding_routes.dart';
import 'auth_controller.dart';
import 'auth_routes.dart';

class AuthView extends GetView<AuthController> {
  const AuthView({super.key});

  static const route = AuthRoutes.route;

  @override
  Widget build(BuildContext context) {
    final palette = Get.find<AppController>().palette;
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: palette.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
            child: HardShadowBox(
              backgroundColor: palette.surface,
              borderRadius: 28,
              padding: const EdgeInsets.all(24),
              child: Form(
                key: controller.formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('brand_title'.tr, style: theme.textTheme.displayMedium),
                    Text('brand_subtitle'.tr.toUpperCase(), style: theme.textTheme.bodyMedium),
                    const SizedBox(height: 24),
                    HardShadowBox(
                      backgroundColor: palette.card,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('email'.tr, style: theme.textTheme.bodySmall),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: controller.emailController,
                            decoration: InputDecoration(hintText: 'email'.tr),
                            validator: (value) => value != null && value.contains('@') ? null : 'email'.tr,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    HardShadowBox(
                      backgroundColor: palette.card,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('password'.tr, style: theme.textTheme.bodySmall),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: controller.passwordController,
                            obscureText: true,
                            decoration: InputDecoration(hintText: 'password'.tr),
                            validator: (value) => (value ?? '').length >= 6 ? null : 'password'.tr,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    Obx(
                      () => controller.isLogin.value
                          ? const SizedBox.shrink()
                          : HardShadowBox(
                              backgroundColor: palette.card,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('confirm_password'.tr, style: theme.textTheme.bodySmall),
                                  const SizedBox(height: 6),
                                  TextFormField(
                                    controller: controller.confirmPasswordController,
                                    obscureText: true,
                                    decoration: InputDecoration(hintText: 'confirm_password'.tr),
                                    validator: controller.validateConfirm,
                                  ),
                                ],
                              ),
                            ),
                    ),
                    const SizedBox(height: 24),
                    Obx(
                      () => GestureDetector(
                        onTap: controller.isLoading.value ? null : controller.submit,
                        child: HardShadowBox(
                          backgroundColor: palette.chat,
                          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (controller.isLoading.value)
                                const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(strokeWidth: 3, color: Colors.black),
                                )
                              else
                                Text(
                                  controller.isLogin.value ? 'sign_in'.tr : 'create_account'.tr,
                                  style: theme.textTheme.bodyMedium,
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Obx(
                      () => GestureDetector(
                        onTap: controller.toggleMode,
                        child: HardShadowBox(
                          backgroundColor: palette.surface,
                          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                controller.isLogin.value ? 'no_account'.tr : 'have_account'.tr,
                                style: theme.textTheme.bodySmall,
                              ),
                              const Icon(Icons.swap_horiz, color: Colors.black),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => Get.offAllNamed(OnboardingRoutes.route),
                        child: Text('skip'.tr, style: theme.textTheme.bodySmall),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => Get.offAllNamed(HomeRoutes.route),
                        child: Text('market'.tr, style: theme.textTheme.bodySmall),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
