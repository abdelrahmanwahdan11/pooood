import 'package:get/get.dart';

import '../../data/models/product.dart';
import '../../data/models/store_location.dart';
import '../../data/models/user_alert.dart';
import '../../data/repositories/product_repo.dart';
import '../../services/location_service.dart';
import '../../services/notification_service.dart';
import '../../services/pricing_service.dart';
import '../../services/trend_service.dart';

class ProductDetailController extends GetxController {
  ProductDetailController({
    required this.productRepository,
    required this.locationService,
    required this.pricingService,
    required this.notificationService,
    required this.trendService,
  });

  final ProductRepository productRepository;
  final LocationService locationService;
  final PricingService pricingService;
  final NotificationService notificationService;
  final TrendService trendService;

  final product = Rxn<Product>();
  final nearbyStores = <StoreLocation>[].obs;
  final similarProducts = <Product>[].obs;
  final estimatedPrice = 0.0.obs;
  final isFavorite = false.obs;

  @override
  void onInit() {
    super.onInit();
    final id = Get.parameters['id'];
    if (id != null) {
      loadProduct(id);
    }
  }

  Future<void> loadProduct(String id) async {
    final loaded = await productRepository.getProductById(id);
    product.value = loaded;
    estimatedPrice.value = pricingService.estimatePrice(loaded);
    final stores = await locationService.nearbyStores();
    nearbyStores.assignAll(stores);
    similarProducts.assignAll(await trendService.trendingProducts(categoryId: loaded.categoryId));
  }

  void toggleFavorite() {
    final current = product.value;
    if (current == null) return;
    productRepository.toggleFavorite(current.id);
    isFavorite.toggle();
  }

  void createPriceAlert(double targetPrice) {
    final current = product.value;
    if (current == null) return;
    notificationService.upsertAlert(
      UserAlert(
        id: '${current.id}_$targetPrice',
        productId: current.id,
        targetPrice: targetPrice,
        isActive: true,
      ),
    );
    Get.snackbar('price_alerts'.tr, 'alert_created'.tr);
  }
}
