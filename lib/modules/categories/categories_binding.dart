import 'package:get/get.dart';

import '../../data/datasources/remote/stub_api_ds.dart';
import 'category_controller.dart';

class CategoriesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CategoryController>(() => CategoryController(Get.find<StubApiDataSource>()));
  }
}
