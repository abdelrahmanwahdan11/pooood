import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<bool> ensurePermission() async {
    final status = await Geolocator.checkPermission();
    if (status == LocationPermission.always || status == LocationPermission.whileInUse) {
      return true;
    }
    final requested = await Geolocator.requestPermission();
    return requested == LocationPermission.always ||
        requested == LocationPermission.whileInUse;
  }

  Future<Position?> currentPosition() async {
    final granted = await ensurePermission();
    if (!granted) return null;
    return Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }
}
