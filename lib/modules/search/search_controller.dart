import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../core/utils/debouncer.dart';
import '../../data/datasources/remote/stub_api_ds.dart';
import '../../data/models/product.dart';
import '../../data/repositories/product_repo.dart';

class SearchController extends GetxController {
  SearchController(this.productRepository, this.remoteDataSource)
      : storage = Get.find<GetStorage>();

  final ProductRepository productRepository;
  final StubApiDataSource remoteDataSource;
  final GetStorage storage;

  final query = ''.obs;
  final results = <Product>[].obs;
  final suggestions = <String>[].obs;
  final history = <String>[].obs;
  final isSearching = false.obs;
  final Debouncer debouncer = Debouncer();

  @override
  void onInit() {
    super.onInit();
    history.assignAll((storage.read<List<dynamic>>('search_history') ?? []).cast<String>());
    loadSuggestions();
  }

  Future<void> loadSuggestions() async {
    final data = await remoteDataSource.fetchSearchSuggestions();
    suggestions.assignAll(data.cast<String>());
  }

  void onQueryChanged(String value) {
    query.value = value;
    debouncer(() => search(value));
  }

  Future<void> search(String value) async {
    if (value.isEmpty) {
      results.clear();
      return;
    }
    isSearching.value = true;
    final data = await productRepository.searchProducts(value);
    results.assignAll(data);
    isSearching.value = false;
  }

  void saveToHistory(String value) {
    if (value.isEmpty) return;
    history.remove(value);
    history.insert(0, value);
    if (history.length > 10) history.removeLast();
    storage.write('search_history', history);
  }
}
