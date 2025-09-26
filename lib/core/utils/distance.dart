import 'dart:math';

import '../../data/models/geo_point.dart';

class DistanceUtils {
  const DistanceUtils._();

  static double distanceKm(GeoPoint a, GeoPoint b) {
    const earthRadius = 6371.0;
    final dLat = _deg2rad(b.latitude - a.latitude);
    final dLon = _deg2rad(b.longitude - a.longitude);
    final lat1 = _deg2rad(a.latitude);
    final lat2 = _deg2rad(b.latitude);
    final hav = sin(dLat / 2) * sin(dLat / 2) +
        sin(dLon / 2) * sin(dLon / 2) * cos(lat1) * cos(lat2);
    final c = 2 * atan2(sqrt(hav), sqrt(1 - hav));
    return earthRadius * c;
  }

  static double _deg2rad(double deg) => deg * pi / 180;
}
