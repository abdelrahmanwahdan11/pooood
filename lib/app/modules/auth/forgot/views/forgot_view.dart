import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/utils/layout_helper.dart';
import '../controllers/forgot_controller.dart';

class ForgotView extends GetView<ForgotController> {
  const ForgotView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('forgot_password'.tr)),
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
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'validation_required'.tr;
                    }
                    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                    if (!regex.hasMatch(value.trim())) {
                      return 'validation_email'.tr;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: controller.submit,
                  style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                  child: Text('submit'.tr),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
