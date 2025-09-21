import 'dart:convert';

import 'package:get_storage/get_storage.dart';

import '../../models/user_alert.dart';

class GetStorageDataSource {
  GetStorageDataSource(this._storage);

  final GetStorage _storage;

  String? get locale => _storage.read<String>('locale');

  set locale(String? value) {
    if (value != null) {
      _storage.write('locale', value);
    }
  }

  bool get onboardingCompleted => _storage.read<bool>('onboarded') ?? false;

  set onboardingCompleted(bool value) => _storage.write('onboarded', value);

  List<String> get favorites => (_storage.read<List<dynamic>>('favorites') ?? []).cast<String>();

  void toggleFavorite(String productId) {
    final favs = favorites;
    if (favs.contains(productId)) {
      favs.remove(productId);
    } else {
      favs.add(productId);
    }
    _storage.write('favorites', favs);
  }

  List<UserAlert> get alerts {
    final raw = _storage.read<String>('alerts');
    if (raw == null) return [];
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded.map((e) => UserAlert.fromJson(e as Map<String, dynamic>)).toList();
  }

  void saveAlerts(List<UserAlert> alerts) {
    final encoded = jsonEncode(alerts.map((e) => e.toJson()).toList());
    _storage.write('alerts', encoded);
  }

  Map<String, dynamic>? get lastLocation => _storage.read<Map<String, dynamic>>('lastLocation');

  void saveLocation({required double lat, required double lng}) {
    _storage.write('lastLocation', {'lat': lat, 'lng': lng});
  }
}
