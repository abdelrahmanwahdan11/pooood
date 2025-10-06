/*
  هذا الملف يدير منطق شاشة البداية مع فحص الجلسة والانتقال للوجهة المناسبة.
  يمكن توسعته لتضمين تحميل بيانات أولية أو إظهار شاشات ترحيبية إضافية.
*/
import 'dart:async';

import 'package:get/get.dart';

import '../../../data/services/storage_service.dart';
import '../../../routes/app_routes.dart';

class SplashController extends GetxController {
  final progress = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    _simulateLoading();
  }

  void _simulateLoading() {
    Timer.periodic(const Duration(milliseconds: 300), (timer) {
      progress.value += 0.2;
      if (progress.value >= 1) {
        timer.cancel();
        _openNext();
      }
    });
  }

  void _openNext() {
    final user = StorageService.to.getUser();
    if (user != null) {
      Get.offAllNamed(AppRoutes.home);
    } else {
      Get.offAllNamed(AppRoutes.login);
    }
  }
}
