import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/routing/app_routes.dart';
import '../../data/datasources/local/get_storage_ds.dart';

class LanguageController extends GetxController {
  LanguageController(this._storage);

  final GetStorageDataSource _storage;

  void selectLocale(Locale locale) {
    Get.updateLocale(locale);
    _storage.write('locale', locale.languageCode);
    Get.offAllNamed(AppRoutes.onboarding);
  }
}
