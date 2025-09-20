import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class NotifyService {
  Future<void> info(String message);
  Future<void> success(String message);
  Future<void> warning(String message);
}

class SnackNotifyService extends GetxService implements NotifyService {
  @override
  Future<void> info(String message) async {
    _show(message: message, background: Get.theme.colorScheme.primary.withOpacity(0.85));
  }

  @override
  Future<void> success(String message) async {
    _show(message: message, background: Colors.greenAccent.withOpacity(0.85));
  }

  @override
  Future<void> warning(String message) async {
    _show(message: message, background: Colors.deepOrangeAccent.withOpacity(0.85));
  }

  void _show({required String message, required Color background}) {
    Get.closeCurrentSnackbar();
    Get.showSnackbar(
      GetSnackBar(
        message: message,
        backgroundColor: background,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 16,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // TODO(FCM): Wire Firebase Cloud Messaging for push notifications tied to favorites updates.
}
