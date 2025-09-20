import 'dart:async';
import 'dart:math';

import 'package:get/get.dart';

abstract class GeoService {
  Future<String> getCountry();
  Future<double> distanceInKm(double lat, double lng);
}

class MockGeoService extends GetxService implements GeoService {
  final _random = Random();
  String _currentCountry = 'US';

  @override
  Future<String> getCountry() async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
    return _currentCountry;
  }

  @override
  Future<double> distanceInKm(double lat, double lng) async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
    return 1 + _random.nextDouble() * 25;
  }

  void updateMockCountry(String countryCode) {
    _currentCountry = countryCode;
  }

  // TODO(Geo): Integrate geolocator & geocoding for accurate device position and address resolution.
}
