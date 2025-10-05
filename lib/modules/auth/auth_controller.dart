import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../main.dart';

class AuthController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final RxBool isLogin = true.obs;
  final RxBool isLoading = false.obs;

  AppController get appController => Get.find<AppController>();

  String? validateConfirm(String? value) {
    if (!isLogin.value && value != passwordController.text) {
      return 'auth_error_password'.tr;
    }
    return null;
  }

  Future<void> submit() async {
    if (!formKey.currentState!.validate()) return;
    isLoading.value = true;
    await appController.authenticate(
      email: emailController.text,
      password: passwordController.text,
    );
    isLoading.value = false;
  }

  void toggleMode() {
    isLogin.toggle();
    confirmPasswordController.clear();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
