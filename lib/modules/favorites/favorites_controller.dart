import 'package:get/get.dart';

import '../../data/models/product.dart';
import '../../data/repositories/product_repo.dart';

class FavoritesController extends GetxController {
  FavoritesController(this.productRepository);

  final ProductRepository productRepository;

  final favorites = <Product>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    isLoading.value = true;
    favorites.assignAll(await productRepository.favorites());
    isLoading.value = false;
  }
}
