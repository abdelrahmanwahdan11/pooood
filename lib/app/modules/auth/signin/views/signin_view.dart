import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/utils/layout_helper.dart';
import '../controllers/signin_controller.dart';

class SignInView extends GetView<SignInController> {
  const SignInView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('sign_in'.tr)),
      body: LayoutHelper.constrain(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: controller.emailController,
                  decoration: InputDecoration(labelText: 'auth_email'.tr),
                  validator: _emailValidator,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: controller.passwordController,
                  decoration: InputDecoration(labelText: 'auth_password'.tr),
                  obscureText: true,
                  validator: _passwordValidator,
                ),
                const SizedBox(height: 24),
                Obx(
                  () => FilledButton(
                    onPressed: controller.isLoading.value ? null : controller.submit,
                    style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                    child: controller.isLoading.value
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                        : Text('sign_in'.tr),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: controller.goToForgot,
                  child: Text('forgot_password'.tr),
                ),
                TextButton(
                  onPressed: controller.goToSignup,
                  child: Text('sign_up'.tr),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? _emailValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'validation_required'.tr;
    }
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!regex.hasMatch(value.trim())) {
      return 'validation_email'.tr;
    }
    return null;
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'validation_required'.tr;
    }
    if (value.trim().length < 6) {
      return 'validation_password'.tr;
    }
    return null;
  }
}
