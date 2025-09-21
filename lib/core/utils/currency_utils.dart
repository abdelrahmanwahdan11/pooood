import 'package:get/get.dart';

String currentCurrency() {
  final locale = Get.locale?.languageCode ?? 'en';
  switch (locale) {
    case 'ar':
      return 'SAR';
    default:
      return 'USD';
  }
}
