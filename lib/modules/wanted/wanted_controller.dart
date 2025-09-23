import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../data/models/geo_point.dart';
import '../../data/models/wanted_request.dart';
import '../../data/repositories/wanted_repo.dart';
import '../../services/location_service.dart';

class WantedController extends GetxController {
  WantedController(this._wantedRepository, this._locationService);

  final WantedRepository _wantedRepository;
  final LocationService _locationService;

  final wanted = <WantedRequest>[].obs;
  final isLoading = true.obs;

  final titleController = TextEditingController();
  final priceController = TextEditingController();
  final radiusController = TextEditingController(text: '10');

  @override
  void onInit() {
    super.onInit();
    loadWanted();
  }

  Future<void> loadWanted() async {
    isLoading.value = true;
    final data = await _wantedRepository.fetchWanted();
    wanted.assignAll(data);
    isLoading.value = false;
  }

  Future<void> createWanted() async {
    if (titleController.text.trim().isEmpty ||
        priceController.text.trim().isEmpty) {
      Get.snackbar('wanted'.tr, 'field_required'.tr);
      return;
    }
    final position = await _locationService.determinePosition();
    if (position == null) {
      Get.snackbar('wanted'.tr, 'enable_location'.tr);
      return;
    }
    final request = WantedRequest(
      id: const Uuid().v4(),
      // TODO: replace with authenticated user id.
      userId: 'mock_user',
      title: titleController.text.trim(),
      targetPrice: double.tryParse(priceController.text.trim()) ?? 0,
      radiusKm: double.tryParse(radiusController.text.trim()) ?? 10,
      location: GeoPointModel(
        latitude: position.latitude,
        longitude: position.longitude,
      ),
      createdAt: DateTime.now(),
    );
    wanted.add(request);
    await _wantedRepository.createWanted(request);
    Get.back();
    Get.snackbar('wanted'.tr, 'notify_success'.tr);
  }

  @override
  void onClose() {
    titleController.dispose();
    priceController.dispose();
    radiusController.dispose();
    super.onClose();
  }
}
