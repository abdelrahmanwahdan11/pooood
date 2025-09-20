import 'dart:ui';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

/// Service responsible for persisting and toggling the application locale.
class LocaleService extends GetxService {
  LocaleService({GetStorage? storage}) : _storage = storage ?? GetStorage();

  static const _storageKey = 'locale';
  final GetStorage _storage;
  final Rx<Locale> _locale = const Locale('en', 'US').obs;

  Locale get locale => _locale.value;

  bool get isArabic => locale.languageCode.toLowerCase() == 'ar';

  Future<LocaleService> init() async {
    final savedTag = _storage.read<String>(_storageKey);
    if (savedTag != null) {
      _locale.value = _parseLanguageTag(savedTag);
    } else {
      final device = Get.deviceLocale;
      if (device != null) {
        _locale.value = _normalizeLocale(device);
      }
    }
    Get.updateLocale(_locale.value);
    return this;
  }

  void updateLocale(Locale locale) {
    final normalized = _normalizeLocale(locale);
    _locale.value = normalized;
    _storage.write(_storageKey, _toLanguageTag(normalized));
    Get.updateLocale(normalized);
  }

  Locale toggleLocale() {
    final newLocale = isArabic ? const Locale('en', 'US') : const Locale('ar', 'SA');
    updateLocale(newLocale);
    return newLocale;
  }

  static Locale _normalizeLocale(Locale input) {
    final language = input.languageCode.toLowerCase();
    switch (language) {
      case 'ar':
        return const Locale('ar', 'SA');
      default:
        return const Locale('en', 'US');
    }
  }

  static Locale _parseLanguageTag(String tag) {
    final segments = tag.split('-');
    if (segments.length == 2) {
      return Locale(segments.first, segments.last);
    }
    if (segments.length == 3) {
      return Locale(segments.first, segments.last);
    }
    return Locale(tag);
  }

  static String _toLanguageTag(Locale locale) {
    if (locale.countryCode?.isNotEmpty ?? false) {
      return '${locale.languageCode}-${locale.countryCode}';
    }
    return locale.languageCode;
  }
}
