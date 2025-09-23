import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';

import '../../core/utils/distance.dart';
import '../../data/models/deal.dart';
import '../../data/models/product.dart';
import '../../data/repositories/deal_repo.dart';
import '../../data/repositories/product_repo.dart';
import '../../services/location_service.dart';

class DealsController extends GetxController {
  DealsController(this._dealRepository, this._productRepository, this._locationService);

  final DealRepository _dealRepository;
  final ProductRepository _productRepository;
  final LocationService _locationService;

  final deals = <Deal>[].obs;
  final products = <String, Product>{}.obs;
  final isLoading = true.obs;
  Position? position;

  @override
  void onInit() {
    super.onInit();
    loadDeals();
    _initLocation();
  }

  Future<void> _initLocation() async {
    position = await _locationService.determinePosition();
    _sort();
  }

  Future<void> loadDeals() async {
    isLoading.value = true;
    final result = await _dealRepository.fetchDeals();
    deals.assignAll(result);
    for (final deal in result) {
      final product = await _productRepository.fetchProduct(deal.productId);
      if (product != null) products[product.id] = product;
    }
    _sort();
    isLoading.value = false;
  }

  Product? productFor(Deal deal) => products[deal.productId];

  void _sort() {
    final current = position;
    if (current == null) return;
    deals.sort((a, b) {
      final prodA = products[a.productId];
      final prodB = products[b.productId];
      final distA = prodA != null
          ? DistanceUtils.haversineDistance(
              startLat: current.latitude,
              startLng: current.longitude,
              endLat: prodA.location.latitude,
              endLng: prodA.location.longitude,
            )
          : double.infinity;
      final distB = prodB != null
          ? DistanceUtils.haversineDistance(
              startLat: current.latitude,
              startLng: current.longitude,
              endLat: prodB.location.latitude,
              endLng: prodB.location.longitude,
            )
          : double.infinity;
      return distA.compareTo(distB);
    });
  }
}
