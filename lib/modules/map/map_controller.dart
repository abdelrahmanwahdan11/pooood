import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';

import '../../data/models/wanted_request.dart';
import '../../data/repositories/wanted_repo.dart';
import '../../services/location_service.dart';

class MapController extends GetxController {
  MapController(this._wantedRepository, this._locationService);

  final WantedRepository _wantedRepository;
  final LocationService _locationService;

  final wanted = <WantedRequest>[].obs;
  final markers = <Marker>{}.obs;
  GoogleMapController? mapController;

  @override
  void onInit() {
    super.onInit();
    ever(wanted, (_) => _updateMarkers());
    loadWanted();
  }

  Future<void> loadWanted() async {
    final data = await _wantedRepository.fetchWanted();
    wanted.assignAll(data);
    _updateMarkers();
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _focusUser();
  }

  Future<void> _focusUser() async {
    final position = await _locationService.determinePosition();
    if (position == null || mapController == null) return;
    mapController!.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 10,
        ),
      ),
    );
  }

  void _updateMarkers() {
    markers.value = wanted
        .map(
          (request) => Marker(
            markerId: MarkerId(request.id),
            position: LatLng(
              request.location.latitude,
              request.location.longitude,
            ),
            infoWindow: InfoWindow(
              title: request.title,
              snippet: '${request.targetPrice.toStringAsFixed(0)}',
            ),
          ),
        )
        .toSet();
  }
}
