import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/services/locale_service.dart';
import '../../../routes/app_routes.dart';

class LanguageSelectController extends GetxController {
  LanguageSelectController({required LocaleService localeService})
      : _localeService = localeService,
        selectedLocale = localeService.locale.obs;

  final LocaleService _localeService;
  final Rx<Locale> selectedLocale;

  void selectLocale(Locale locale) {
    selectedLocale.value = locale;
    _localeService.updateLocale(locale);
  }

  void proceed() {
    Get.offAllNamed(Routes.onboarding);
  }
}
