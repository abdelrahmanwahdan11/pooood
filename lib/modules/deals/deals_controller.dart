import 'package:get/get.dart';

import '../../data/models/discount.dart';
import '../../data/repositories/auction_repo.dart';
import '../../services/location_service.dart';

class DealsController extends GetxController {
  DealsController(this.auctionRepository, this.locationService);

  final AuctionRepository auctionRepository;
  final LocationService locationService;

  final deals = <Discount>[].obs;
  final region = 'global'.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    isLoading.value = true;
    final data = await auctionRepository.fetchDeals();
    deals.assignAll(data);
    final coords = await locationService.getOrRequestLocation();
    if (coords['lat']! >= 20 && coords['lat']! <= 32) {
      region.value = 'mena';
    }
    isLoading.value = false;
  }

  void filterByRegion(String value) {
    region.value = value;
  }
}
