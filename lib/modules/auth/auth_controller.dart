import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/routing/app_routes.dart';
import '../../data/repositories/settings_repo.dart';
import '../../data/repositories/watch_store_repo.dart';

enum AuthStage { login, register, verify }

class AuthController extends GetxController {
  AuthController(this.settingsRepository, this.watchStoreRepository);

  final SettingsRepository settingsRepository;
  final WatchStoreRepository watchStoreRepository;

  final loginFormKey = GlobalKey<FormState>();
  final registerFormKey = GlobalKey<FormState>();
  final otpFormKey = GlobalKey<FormState>();

  late final TextEditingController loginEmailController;
  late final TextEditingController loginPasswordController;
  late final TextEditingController registerNameController;
  late final TextEditingController registerEmailController;
  late final TextEditingController registerPasswordController;
  late final TextEditingController registerConfirmController;
  late final TextEditingController otpController;

  final stage = AuthStage.login.obs;
  final rememberMe = true.obs;
  final obscurePassword = true.obs;
  final acceptTerms = true.obs;
  final isLoading = false.obs;
  final isLoggedIn = false.obs;
  final isGuest = false.obs;
  final canResendCode = false.obs;
  final countdown = 30.obs;
  final authError = RxnString();

  Timer? _timer;
  String _pendingOtp = '';
  String? _pendingEmail;
  String? _pendingName;

  @override
  void onInit() {
    loginEmailController = TextEditingController(text: settingsRepository.userEmail ?? '');
    loginPasswordController = TextEditingController();
    registerNameController = TextEditingController(text: settingsRepository.userName ?? '');
    registerEmailController = TextEditingController(text: settingsRepository.userEmail ?? '');
    registerPasswordController = TextEditingController();
    registerConfirmController = TextEditingController();
    otpController = TextEditingController();
    isGuest.value = settingsRepository.isGuestMode;
    if (settingsRepository.authToken != null || settingsRepository.isGuestMode) {
      isLoggedIn.value = true;
    }
    super.onInit();
  }

  @override
  void onClose() {
    loginEmailController.dispose();
    loginPasswordController.dispose();
    registerNameController.dispose();
    registerEmailController.dispose();
    registerPasswordController.dispose();
    registerConfirmController.dispose();
    otpController.dispose();
    _timer?.cancel();
    super.onClose();
  }

  void goToStage(AuthStage next) {
    stage.value = next;
    authError.value = null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'required_field'.tr;
    }
    final emailRegex = RegExp(r"^[\\w-.]+@[\\w-]+\\.[A-Za-z]{2,4}");
    if (!emailRegex.hasMatch(value.trim())) {
      return 'invalid_email'.tr;
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'required_field'.tr;
    }
    if (value.length < 8) {
      return 'password_length'.tr;
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'password_upper'.tr;
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'password_number'.tr;
    }
    return null;
  }

  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'required_field'.tr;
    }
    if (value.trim().length < 2) {
      return 'name_length'.tr;
    }
    return null;
  }

  Future<void> login() async {
    if (!(loginFormKey.currentState?.validate() ?? false)) return;
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 420));
    final signature = _sign(loginPasswordController.text.trim());
    if (settingsRepository.credentialsMatch(
      loginEmailController.text.trim(),
      signature,
    )) {
      await settingsRepository.updateAuthSession(
        token: _generateToken(),
        email: settingsRepository.userEmail,
        name: settingsRepository.userName,
        guestMode: false,
      );
      await settingsRepository.setGuestMode(false);
      isLoggedIn.value = true;
      isGuest.value = false;
      authError.value = null;
      Get.offAllNamed(AppRoutes.shell);
    } else {
      authError.value = 'invalid_credentials'.tr;
    }
    isLoading.value = false;
  }

  Future<void> register() async {
    if (!acceptTerms.value) {
      authError.value = 'accept_terms'.tr;
      return;
    }
    if (!(registerFormKey.currentState?.validate() ?? false)) return;
    if (registerPasswordController.text.trim() !=
        registerConfirmController.text.trim()) {
      authError.value = 'password_mismatch'.tr;
      return;
    }
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 420));
    _pendingOtp = _generateOtp();
    _pendingEmail = registerEmailController.text.trim();
    _pendingName = registerNameController.text.trim();
    _prepareOtpFlow();
    stage.value = AuthStage.verify;
    isLoading.value = false;
  }

  Future<void> resendCode() async {
    if (!canResendCode.value) return;
    if (_pendingEmail == null) return;
    _pendingOtp = _generateOtp();
    _prepareOtpFlow();
  }

  Future<void> verify() async {
    if (!(otpFormKey.currentState?.validate() ?? false)) return;
    if (otpController.text.trim() != _pendingOtp) {
      authError.value = 'invalid_code'.tr;
      return;
    }
    final signature = _sign(registerPasswordController.text.trim());
    await settingsRepository.storeCredentials(
      email: _pendingEmail!,
      name: _pendingName!,
      signature: signature,
    );
    await settingsRepository.updateAuthSession(
      token: _generateToken(),
      email: _pendingEmail,
      name: _pendingName,
      guestMode: false,
    );
    await settingsRepository.setGuestMode(false);
    isLoggedIn.value = true;
    isGuest.value = false;
    authError.value = null;
    _pendingOtp = '';
    stage.value = AuthStage.login;
    Get.offAllNamed(AppRoutes.shell);
  }

  Future<void> loginAsGuest() async {
    await settingsRepository.updateAuthSession(
      token: 'guest-${DateTime.now().millisecondsSinceEpoch}',
      email: null,
      name: 'guest_name'.tr,
      guestMode: true,
    );
    await settingsRepository.setGuestMode(true);
    isGuest.value = true;
    isLoggedIn.value = true;
    Get.offAllNamed(AppRoutes.shell);
  }

  Future<void> signOut() async {
    await settingsRepository.clearSession();
    isGuest.value = false;
    isLoggedIn.value = false;
    stage.value = AuthStage.login;
    loginPasswordController.clear();
    authError.value = null;
    Get.offAllNamed(AppRoutes.auth);
  }

  String? validateOtp(String? value) {
    if (value == null || value.isEmpty) {
      return 'required_field'.tr;
    }
    if (value.length != 6) {
      return 'otp_length'.tr;
    }
    return null;
  }

  String _generateOtp() {
    final rand = Random();
    return List.generate(6, (_) => rand.nextInt(10).toString()).join();
  }

  String _generateToken() {
    final rand = Random();
    final bytes = List<int>.generate(16, (_) => rand.nextInt(255));
    return base64UrlEncode(bytes);
  }

  String _sign(String password) {
    final normalized = password.trim();
    final reversed = normalized.split('').reversed.join();
    return base64Url.encode(utf8.encode('$normalized:$reversed'));
  }

  void _prepareOtpFlow() {
    canResendCode.value = false;
    countdown.value = 30;
    otpController.clear();
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      countdown.value--;
      if (countdown.value <= 0) {
        canResendCode.value = true;
        timer.cancel();
      }
    });
  }
}
