import 'package:get/get.dart';

import '../../data/datasources/remote/stub_api_ds.dart';
import '../../data/repositories/product_repo.dart';
import 'search_controller.dart';

class SearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SearchController>(() => SearchController(Get.find<ProductRepository>(), Get.find<StubApiDataSource>()));
  }
}
