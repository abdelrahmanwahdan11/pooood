import 'package:get/get.dart';

class Validators {
  static String? requiredField(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'required_field'.tr;
    }
    return null;
  }

  static String? positiveNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'required_field'.tr;
    }
    final number = double.tryParse(value.replaceAll(',', '.'));
    if (number == null || number <= 0) {
      return 'invalid_number'.tr;
    }
    return null;
  }

  static String? url(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    final uri = Uri.tryParse(value);
    if (uri == null || (!uri.isScheme('http') && !uri.isScheme('https'))) {
      return 'invalid_url'.tr;
    }
    return null;
  }
}
