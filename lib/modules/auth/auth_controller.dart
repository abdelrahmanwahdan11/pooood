import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/routing/app_routes.dart';
import '../../data/datasources/local/get_storage_ds.dart';
import '../../services/notification_service.dart';

class AuthController extends GetxController {
  AuthController(this._storage, this._notificationService);

  final GetStorageDataSource _storage;
  final NotificationService _notificationService;

  final loginEmailController = TextEditingController();
  final loginPasswordController = TextEditingController();
  final signupEmailController = TextEditingController();
  final signupPasswordController = TextEditingController();
  final isLoginLoading = false.obs;
  final isSignupLoading = false.obs;

  void login() async {
    isLoginLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 600));
    isLoginLoading.value = false;
    _notificationService.getAlerts();
    Get.offAllNamed(AppRoutes.home);
  }

  void signup() async {
    isSignupLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 800));
    isSignupLoading.value = false;
    _notificationService.getAlerts();
    Get.offAllNamed(AppRoutes.home);
  }

  @override
  void onClose() {
    loginEmailController.dispose();
    loginPasswordController.dispose();
    signupEmailController.dispose();
    signupPasswordController.dispose();
    super.onClose();
  }

  // TODO: Firebase
  // 1) إضافة firebase_auth, google_sign_in, sign_in_with_apple إلى pubspec.
  // 2) تهيئة Firebase في main.dart واستدعاء FirebaseAuth.instance.
  // 3) إنشاء طرق تسجيل (Email/Password, Phone, Apple, Google) وتخزين المستخدم داخل Firestore.
  // 4) تحديث NotificationService لاستخدام uid كمفتاح للتنبيهات.
  // 5) إضافة التحقق المتقدم (reCAPTCHA للهاتف) وتحديث قواعد الأمان.
}
