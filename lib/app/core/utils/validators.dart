/*
  هذا الملف يحتوي دوال التحقق من صحة المدخلات وفق المتطلبات المحددة.
  يمكن إضافة قواعد جديدة بسهولة وتحديث النصوص المرتبطة بها.
*/
import 'package:get/get.dart';

class Validators {
  static String? validateNonEmpty(String value) {
    if (value.trim().isEmpty) {
      return 'validators.required';
    }
    return null;
  }

  static String? validateEmail(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return 'validators.required';
    }
    if (!GetUtils.isEmail(trimmed)) {
      return 'validators.email';
    }
    return null;
  }

  static String? validatePhone(String value) {
    final digits = value.trim();
    if (digits.isEmpty) {
      return 'validators.required';
    }
    if (digits.length < 8 || digits.length > 15 || !digits.characters.every((c) => int.tryParse(c) != null)) {
      return 'validators.phone';
    }
    return null;
  }

  static String? validatePassword(String value) {
    if (value.isEmpty) {
      return 'validators.required';
    }
    final hasUpper = value.contains(RegExp('[A-Z]'));
    final hasLower = value.contains(RegExp('[a-z]'));
    final hasDigit = value.contains(RegExp('[0-9]'));
    final hasSpecial = value.contains(RegExp('[!@#\$&*~]'));
    if (value.length < 8 || !hasUpper || !hasLower || !hasDigit || !hasSpecial) {
      return 'validators.password';
    }
    return null;
  }

  static String? validatePrice(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return 'validators.required';
    }
    final parsed = double.tryParse(trimmed);
    if (parsed == null || parsed <= 0) {
      return 'validators.price';
    }
    return null;
  }
}
