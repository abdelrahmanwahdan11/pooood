/*
  هذا الملف يضم دوال مساعدة للتنسيق والحسابات المشتركة داخل التطبيق.
  يمكن إضافة دوال جديدة بسهولة لتلبية احتياجات الواجهات المختلفة.
*/
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Helpers {
  static final NumberFormat _currency = NumberFormat.compactCurrency(symbol: '\$');

  static String formatCurrency(double value) => _currency.format(value);

  static String formatCountdown(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  static Future<void> showSnackBar({
    required BuildContext context,
    required String title,
    required String message,
    bool isError = false,
  }) async {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.redAccent : Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
