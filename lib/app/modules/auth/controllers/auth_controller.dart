/*
  هذا الملف يدير منطق المصادقة وتحقّق النماذج مع دعم الضيف وتخزين الجلسة.
  يمكن تطويره لإضافة تفعيلات بريدية أو ربط مزودي هوية إضافيين.
*/
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/utils/validators.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/services/storage_service.dart';
import '../../../routes/app_routes.dart';

class AuthController extends GetxController {
  final loginFormKey = GlobalKey<FormState>();
  final signupFormKey = GlobalKey<FormState>();

  final loginEmailController = TextEditingController();
  final loginPasswordController = TextEditingController();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  final isLoading = false.obs;
  final rememberMe = true.obs;

  @override
  void onClose() {
    loginEmailController.dispose();
    loginPasswordController.dispose();
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  Future<void> login() async {
    if (!(loginFormKey.currentState?.validate() ?? false)) return;
    try {
      isLoading.value = true;
      await AuthService.to.login(
        email: loginEmailController.text.trim(),
        password: loginPasswordController.text,
      );
      Get.snackbar('auth.login'.tr, 'auth.loginSuccess'.tr, snackPosition: SnackPosition.BOTTOM);
      Get.offAllNamed(AppRoutes.home);
    } catch (error) {
      final key = error.toString();
      Get.snackbar('auth.error'.tr, key.tr, snackPosition: SnackPosition.BOTTOM, backgroundColor: Get.theme.colorScheme.errorContainer);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signup() async {
    if (!(signupFormKey.currentState?.validate() ?? false)) return;
    try {
      isLoading.value = true;
      await AuthService.to.signup(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
        password: passwordController.text,
      );
      Get.snackbar('auth.signup'.tr, 'auth.signupSuccess'.tr, snackPosition: SnackPosition.BOTTOM);
      Get.offAllNamed(AppRoutes.home);
    } catch (error) {
      final key = error.toString();
      Get.snackbar('auth.error'.tr, key.tr, snackPosition: SnackPosition.BOTTOM, backgroundColor: Get.theme.colorScheme.errorContainer);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> guestLogin() async {
    try {
      isLoading.value = true;
      await AuthService.to.guestLogin();
      Get.snackbar('auth.guest'.tr, 'auth.guestWelcome'.tr, snackPosition: SnackPosition.BOTTOM);
      Get.offAllNamed(AppRoutes.home);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await AuthService.to.logout();
    await StorageService.to.saveFavorites([]);
    Get.offAllNamed(AppRoutes.login);
  }

  String? validateLoginEmail(String? value) => Validators.validateEmail(value ?? '');

  String? validateLoginPassword(String? value) => Validators.validatePassword(value ?? '');

  String? validateSignupName(String? value) => Validators.validateNonEmpty(value ?? '');

  String? validateSignupEmail(String? value) => Validators.validateEmail(value ?? '');

  String? validateSignupPhone(String? value) => Validators.validatePhone(value ?? '');

  String? validateSignupPassword(String? value) => Validators.validatePassword(value ?? '');
}
