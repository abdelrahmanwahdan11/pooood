import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }

  Future<void> submit() async {
    if (!(formKey.currentState?.validate() ?? false)) return;
    await Future.delayed(const Duration(milliseconds: 700));
    Get.snackbar('forgot_password'.tr, 'snackbar_saved'.tr, snackPosition: SnackPosition.BOTTOM);
  }
}
