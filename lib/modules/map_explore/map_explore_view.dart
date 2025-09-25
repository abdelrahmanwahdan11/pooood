import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'map_explore_controller.dart';

class MapExploreView extends GetView<MapExploreController> {
  const MapExploreView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GoogleMap(
        onMapCreated: (map) => controller.mapController = map,
        initialCameraPosition: controller.cameraPosition.value,
        markers: Set<Marker>.from(controller.markers),
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        compassEnabled: true,
      ),
    );
  }
}
