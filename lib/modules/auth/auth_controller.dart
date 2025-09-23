import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/routing/app_routes.dart';
import '../../core/utils/validators.dart';
import '../../services/auth_service.dart';
import '../../services/notification_service.dart';

class AuthController extends GetxController {
  AuthController(this._authService, this._notificationService);

  final AuthService _authService;
  final NotificationService _notificationService;

  final loginFormKey = GlobalKey<FormState>();
  final signupFormKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();

  final isLoading = false.obs;

  String? validateEmail(String? value) {
    final validation = Validators.email(value);
    return validation != null ? validation.tr : null;
  }

  String? validatePassword(String? value) {
    final validation = Validators.password(value);
    return validation != null ? validation.tr : null;
  }

  Future<void> login() async {
    if (!(loginFormKey.currentState?.validate() ?? false)) return;
    isLoading.value = true;
    try {
      await _authService.signInWithEmail(
        emailController.text.trim(),
        passwordController.text.trim(),
      );
      await _notificationService.registerUserTopics();
      Get.offAllNamed(AppRoutes.home);
    } on Exception catch (e) {
      Get.snackbar('login'.tr, e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signup() async {
    if (!(signupFormKey.currentState?.validate() ?? false)) return;
    if (passwordController.text.trim() !=
        confirmPasswordController.text.trim()) {
      Get.snackbar('signup'.tr, 'password_short'.tr);
      return;
    }
    isLoading.value = true;
    try {
      final credential = await _authService.signUpWithEmail(
        emailController.text.trim(),
        passwordController.text.trim(),
      );
      if (fullNameController.text.isNotEmpty) {
        await credential.user?.updateDisplayName(fullNameController.text.trim());
      }
      await _notificationService.registerUserTopics();
      Get.offAllNamed(AppRoutes.home);
    } on Exception catch (e) {
      Get.snackbar('signup'.tr, e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void goToSignup() => Get.toNamed(AppRoutes.signup);

  void goToLogin() => Get.offAllNamed(AppRoutes.login);

  Future<void> loginWithGoogle() async {
    await _authService.signInWithGoogle();
  }

  Future<void> loginWithApple() async {
    await _authService.signInWithApple();
  }

  Future<void> loginWithPhone() async {
    if (phoneController.text.isEmpty) {
      Get.snackbar('login'.tr, 'phone_number'.tr);
      return;
    }
    await _authService.signInWithPhone(
      phoneController.text.trim(),
      const Duration(seconds: 60),
    );
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    fullNameController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}
