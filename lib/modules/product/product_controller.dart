import 'package:get/get.dart';

import '../../main.dart';
import '../../models/marketplace_meta.dart';
import '../../models/product.dart';

class ProductController extends GetxController {
  late final Product product;
  final RxDouble rating = 0.0.obs;
  final RxInt carouselIndex = 0.obs;
  late final ProductMeta meta;
  late final Vendor vendor;
  late final List<MarketplaceStory> stories;
  late final List<QaEntry> qa;
  final RxSet<int> expandedQa = <int>{}.obs;

  AppController get appController => Get.find<AppController>();

  @override
  void onInit() {
    super.onInit();
    product = Get.arguments as Product;
    rating.value = appController.ratingFor(product);
    meta = appController.metaFor(product.id);
    vendor = appController.vendorFor(meta.vendorId);
    stories = appController.testimonialsFor(product);
    qa = appController.qaFor(product);
  }

  Future<void> updateRating(double value) async {
    rating.value = value;
    await appController.setRating(product, value);
  }

  void updateCarousel(int index, _) {
    carouselIndex.value = index;
  }

  Future<void> toggleFavorite() => appController.toggleFavorite(product);

  Future<void> toggleCart() => appController.toggleCart(product);

  Future<void> toggleCompare() => appController.toggleCompare(product);

  void shareProduct() => appController.shareProduct(product);

  void downloadSpecs() => appController.downloadSpecs(product);

  void requestRestock() => appController.triggerRestock(product);

  bool isCompared() => appController.isCompared(product);

  void toggleQuestion(int index) {
    if (expandedQa.contains(index)) {
      expandedQa.remove(index);
    } else {
      expandedQa.add(index);
    }
  }
}
