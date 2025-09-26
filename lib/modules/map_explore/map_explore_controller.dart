import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../data/repositories/auction_repository.dart';
import '../../data/repositories/discount_repository.dart';
import '../../services/location_service.dart';
import '../common/widgets/map_pin_bottom_sheet.dart';

class MapExploreController extends GetxController {
  final markers = <Marker>{}.obs;
  final cameraPosition = const CameraPosition(
    target: LatLng(24.7136, 46.6753),
    zoom: 8,
  ).obs;

  GoogleMapController? mapController;

  AuctionRepository get _auctionRepository => Get.find<AuctionRepository>();
  DiscountRepository get _discountRepository => Get.find<DiscountRepository>();
  LocationService get _locationService => Get.find<LocationService>();

  @override
  void onInit() {
    super.onInit();
    _buildMarkers();
    _moveToCurrentLocation();
  }

  Future<void> _moveToCurrentLocation() async {
    final position = await _locationService.currentPosition();
    if (position != null) {
      final target = LatLng(position.latitude, position.longitude);
      cameraPosition.value = CameraPosition(target: target, zoom: 13);
      mapController?.animateCamera(CameraUpdate.newCameraPosition(cameraPosition.value));
    }
  }

  void _buildMarkers() {
    final auctions = _auctionRepository.getAuctions();
    final deals = _discountRepository.getDeals();
    final markerSet = <Marker>{};

    for (final auction in auctions) {
      final marker = Marker(
        markerId: MarkerId('auction_${auction.id}'),
        position: LatLng(auction.location.latitude, auction.location.longitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        onTap: () {
          Get.bottomSheet(
            MapPinBottomSheet.auction(auctionItem: auction),
            backgroundColor: Colors.transparent,
          );
        },
      );
      markerSet.add(marker);
    }

    for (final deal in deals) {
      final marker = Marker(
        markerId: MarkerId('deal_${deal.id}'),
        position: LatLng(deal.location.latitude, deal.location.longitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
        onTap: () {
          Get.bottomSheet(
            MapPinBottomSheet.deal(dealItem: deal),
            backgroundColor: Colors.transparent,
          );
        },
      );
      markerSet.add(marker);
    }

    markers.assignAll(markerSet);
  }
}
