import 'package:get/get.dart';

import '../../main.dart';
import '../../models/product.dart';

class ProductController extends GetxController {
  late final Product product;
  final RxDouble rating = 0.0.obs;
  final RxInt carouselIndex = 0.obs;

  AppController get appController => Get.find<AppController>();

  @override
  void onInit() {
    super.onInit();
    product = Get.arguments as Product;
    rating.value = appController.ratingFor(product);
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
}
