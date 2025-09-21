import 'package:get/get.dart';

import '../../data/repositories/product_repo.dart';
import 'favorites_controller.dart';

class FavoritesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FavoritesController>(() => FavoritesController(Get.find<ProductRepository>()));
  }
}
