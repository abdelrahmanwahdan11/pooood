import 'package:get/get.dart';

import '../../data/datasources/remote/stub_api_ds.dart';
import '../../data/models/category.dart';

class CategoryController extends GetxController {
  CategoryController(this.remoteDataSource);

  final StubApiDataSource remoteDataSource;

  final categories = <Category>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    isLoading.value = true;
    final data = await remoteDataSource.fetchCategories();
    categories.assignAll(data.map((e) => Category.fromJson(e as Map<String, dynamic>)));
    isLoading.value = false;
  }
}
