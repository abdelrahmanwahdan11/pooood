import 'package:get/get.dart';

import '../../data/models/discount_deal.dart';
import '../../data/repositories/discount_repository.dart';

class DiscountsNearbyController extends GetxController {
  final _deals = <DiscountDeal>[].obs;

  DiscountRepository get _repository => Get.find<DiscountRepository>();

  List<DiscountDeal> get deals => _deals;

  @override
  void onInit() {
    super.onInit();
    _deals.assignAll(_repository.getDeals());
  }
}
