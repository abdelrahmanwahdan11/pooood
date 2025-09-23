import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';

import '../../core/routing/app_routes.dart';
import '../../core/utils/debounce.dart';
import '../../core/utils/distance.dart';
import '../../data/models/auction.dart';
import '../../data/models/product.dart';
import '../../data/repositories/auction_repo.dart';
import '../../data/repositories/product_repo.dart';
import '../../services/location_service.dart';

class AuctionsController extends GetxController {
  AuctionsController(
    this._auctionRepository,
    this._productRepository,
    this._locationService,
  );

  final AuctionRepository _auctionRepository;
  final ProductRepository _productRepository;
  final LocationService _locationService;
  final _debouncer = Debouncer();

  final auctions = <Auction>[].obs;
  final filteredAuctions = <Auction>[].obs;
  final products = <String, Product>{}.obs;
  final isLoading = true.obs;
  final searchQuery = ''.obs;
  Position? userPosition;

  @override
  void onInit() {
    super.onInit();
    fetchAuctions();
    _initLocation();
  }

  Future<void> _initLocation() async {
    userPosition = await _locationService.determinePosition();
    _sortByDistance();
  }

  Future<void> fetchAuctions() async {
    isLoading.value = true;
    try {
      final data = await _auctionRepository.fetchAuctions();
      auctions.assignAll(data);
      for (final auction in data) {
        final product = await _productRepository.fetchProduct(auction.productId);
        if (product != null) {
          products[product.id] = product;
        }
      }
      filteredAuctions.assignAll(auctions);
      _sortByDistance();
    } finally {
      isLoading.value = false;
    }
  }

  void search(String value) {
    searchQuery.value = value;
    _debouncer(() {
      final query = value.trim().toLowerCase();
      if (query.isEmpty) {
        filteredAuctions.assignAll(auctions);
      } else {
        filteredAuctions.assignAll(
          auctions.where((auction) {
            final product = products[auction.productId];
            final haystack = '${product?.title ?? ''} ${product?.brand ?? ''}'.toLowerCase();
            return haystack.contains(query);
          }),
        );
      }
      _sortByDistance();
    });
  }

  void openAuction(Auction auction) {
    Get.toNamed('${AppRoutes.auctionDetail}/${auction.id}', arguments: auction.id);
  }

  Product? productFor(Auction auction) => products[auction.productId];

  void _sortByDistance() {
    final position = userPosition;
    if (position == null) return;
    filteredAuctions.sort((a, b) {
      final productA = products[a.productId];
      final productB = products[b.productId];
      final distanceA = productA != null
          ? DistanceUtils.haversineDistance(
              startLat: position.latitude,
              startLng: position.longitude,
              endLat: productA.location.latitude,
              endLng: productA.location.longitude,
            )
          : double.infinity;
      final distanceB = productB != null
          ? DistanceUtils.haversineDistance(
              startLat: position.latitude,
              startLng: position.longitude,
              endLat: productB.location.latitude,
              endLng: productB.location.longitude,
            )
          : double.infinity;
      return distanceA.compareTo(distanceB);
    });
  }
}
