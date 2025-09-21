import 'package:get_storage/get_storage.dart';

import '../../../data/models/price_request.dart';

class GetStorageDataSource {
  GetStorageDataSource(this._storage);

  final GetStorage _storage;

  static const _localeKey = 'locale';
  static const _onboardingKey = 'onboarding_complete';
  static const _lastPriceRequestKey = 'last_price_request';
  static const _darkModeKey = 'dark_mode';

  String? readLocale() => _storage.read<String>(_localeKey);

  Future<void> writeLocale(String locale) => _storage.write(_localeKey, locale);

  bool get onboardingComplete => _storage.read<bool>(_onboardingKey) ?? false;

  Future<void> setOnboardingComplete(bool value) =>
      _storage.write(_onboardingKey, value);

  Future<void> savePriceRequest(PriceRequest request) =>
      _storage.write(_lastPriceRequestKey, request.toJson());

  PriceRequest? readLastPriceRequest() {
    final map = _storage.read<Map<String, dynamic>>(_lastPriceRequestKey);
    if (map == null) return null;
    return PriceRequest.fromJson(Map<String, dynamic>.from(map));
  }

  bool get isDarkMode => _storage.read<bool>(_darkModeKey) ?? false;

  Future<void> setDarkMode(bool value) => _storage.write(_darkModeKey, value);
}
