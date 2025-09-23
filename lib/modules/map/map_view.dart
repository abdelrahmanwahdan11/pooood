import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../core/widgets/empty_state.dart';
import 'map_controller.dart';

class MapView extends GetView<MapController> {
  const MapView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 2,
          child: Obx(
            () => GoogleMap(
              onMapCreated: controller.onMapCreated,
              initialCameraPosition: const CameraPosition(
                target: LatLng(24.774265, 46.738586),
                zoom: 6,
              ),
              markers: controller.markers.value,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
            ),
          ),
        ),
        Expanded(
          child: Obx(() {
            if (controller.wanted.isEmpty) {
              return EmptyState(
                icon: Icons.map_outlined,
                title: 'empty_wanted'.tr,
                subtitle: 'map_description'.tr,
              );
            }
            return ListView.builder(
              itemCount: controller.wanted.length,
              itemBuilder: (_, index) {
                final request = controller.wanted[index];
                return ListTile(
                  title: Text(request.title),
                  subtitle: Text(
                    '${'target_price'.tr}: ${request.targetPrice.toStringAsFixed(0)} • '
                    '${'radius_km'.tr}: ${request.radiusKm.toStringAsFixed(0)}',
                  ),
                  leading: const Icon(Icons.location_on_outlined),
                );
              },
            );
          }),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
