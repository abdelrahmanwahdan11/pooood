import 'package:get/get.dart';

import '../../data/models/discount_deal.dart';
import '../../data/repositories/discounts_repo.dart';
import '../../data/repositories/settings_repo.dart';

class DiscountsController extends GetxController {
  DiscountsController(this.repository, this.settingsRepository);

  final DiscountsRepository repository;
  final SettingsRepository settingsRepository;

  final RxList<DiscountDeal> discounts = RxList<DiscountDeal>([]);
  final RxDouble filterDistance = RxDouble(20.0);
  final RxString filterCategory = RxString('');
  final RxDouble minDiscount = RxDouble(0.0);
  final RxBool onlyOpenNow = RxBool(false);

  @override
  void onInit() {
    super.onInit();
    loadDiscounts();
  }

  Future<void> loadDiscounts() async {
    final data = await repository.fetchDiscounts();
    discounts.assignAll(data);
  }

  List<DiscountDeal> filteredDiscounts() {
    final now = DateTime.now();
    return discounts.where((deal) {
      if (deal.distanceKm > filterDistance.value) return false;
      if (minDiscount.value > 0 && deal.discountPercent < minDiscount.value) {
        return false;
      }
      if (filterCategory.value.isNotEmpty &&
          deal.category != filterCategory.value) {
        return false;
      }
      if (onlyOpenNow.value &&
          !(deal.validFrom.isBefore(now) && deal.validUntil.isAfter(now))) {
        return false;
      }
      return true;
    }).toList();
  }
}
