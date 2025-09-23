import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class LocationService extends GetxService {
  final Rxn<Position> currentPosition = Rxn<Position>();

  Future<Position?> determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar('location'.tr, 'location_services_disabled'.tr);
      return null;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar('location'.tr, 'location_permission_denied'.tr);
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Get.snackbar('location'.tr, 'location_permission_denied_forever'.tr);
      return null;
    }

    final position = await Geolocator.getCurrentPosition();
    currentPosition.value = position;
    return position;
  }

  Future<String?> reverseGeocode(Position position) async {
    final placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
      localeIdentifier: Get.locale?.languageCode,
    );
    if (placemarks.isEmpty) return null;
    final place = placemarks.first;
    return [place.subLocality, place.locality, place.country]
        .where((element) => element != null && element!.isNotEmpty)
        .join(', ');
  }
}
