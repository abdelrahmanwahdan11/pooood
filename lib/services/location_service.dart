import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:geolocator/geolocator.dart';

import '../core/utils/geo_utils.dart';
import '../data/datasources/local/get_storage_ds.dart';
import '../data/models/store_location.dart';
import '../data/repositories/location_repo.dart';

class LocationService {
  LocationService({
    required this.locationRepository,
    required this.storageDataSource,
  });

  final LocationRepository locationRepository;
  final GetStorageDataSource storageDataSource;

  Future<Position?> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return null;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return null;
    }

    return Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  Future<Map<String, double>> getOrRequestLocation() async {
    final cached = storageDataSource.lastLocation;
    if (cached != null) {
      return {'lat': cached['lat'] as double, 'lng': cached['lng'] as double};
    }
    final position = await _determinePosition();
    if (position == null) {
      return {'lat': 24.7136, 'lng': 46.6753}; // Riyadh fallback
    }
    storageDataSource.saveLocation(lat: position.latitude, lng: position.longitude);
    return {'lat': position.latitude, 'lng': position.longitude};
  }

  Future<List<StoreLocation>> nearbyStores() async {
    final coords = await getOrRequestLocation();
    final stores = await locationRepository.fetchStores();
    stores.sort((a, b) {
      final aDist = haversineDistance(
        lat1: coords['lat']!,
        lon1: coords['lng']!,
        lat2: a.lat,
        lon2: a.lng,
      );
      final bDist = haversineDistance(
        lat1: coords['lat']!,
        lon1: coords['lng']!,
        lat2: b.lat,
        lon2: b.lng,
      );
      return aDist.compareTo(bDist);
    });
    return stores.take(5).toList();
  }

  Future<String?> reverseGeocode(double lat, double lng) async {
    final placemarks = await geocoding.placemarkFromCoordinates(lat, lng);
    if (placemarks.isEmpty) return null;
    final place = placemarks.first;
    return '${place.locality}, ${place.country}';
  }
}
