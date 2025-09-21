import 'package:get/get.dart';

import '../../data/repositories/product_repo.dart';
import '../../services/location_service.dart';
import '../../services/notification_service.dart';
import '../../services/pricing_service.dart';
import '../../services/trend_service.dart';
import 'product_detail_controller.dart';

class ProductDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProductDetailController>(
      () => ProductDetailController(
        productRepository: Get.find<ProductRepository>(),
        locationService: Get.find<LocationService>(),
        pricingService: Get.find<PricingService>(),
        notificationService: Get.find<NotificationService>(),
        trendService: Get.find<TrendService>(),
      ),
    );
  }
}
