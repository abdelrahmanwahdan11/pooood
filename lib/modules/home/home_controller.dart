import 'package:get/get.dart';

import '../../data/datasources/remote/stub_api_ds.dart';
import '../../data/models/auction.dart';
import '../../data/models/category.dart';
import '../../data/models/discount.dart';
import '../../data/models/product.dart';
import '../../data/repositories/auction_repo.dart';
import '../../data/repositories/product_repo.dart';
import '../../services/trend_service.dart';

class HomeController extends GetxController {
  HomeController({
    required this.productRepository,
    required this.trendService,
    required this.auctionRepository,
    required this.remoteDataSource,
  });

  final ProductRepository productRepository;
  final TrendService trendService;
  final AuctionRepository auctionRepository;
  final StubApiDataSource remoteDataSource;

  final currentIndex = 0.obs;
  final isLoading = false.obs;
  final categories = <Category>[].obs;
  final selectedCategoryId = RxnString();
  final trendingProducts = <Product>[].obs;
  final auctionItems = <Auction>[].obs;
  final deals = <Discount>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadHome();
  }

  Future<void> loadHome() async {
    isLoading.value = true;
    final data = await Future.wait([
      remoteDataSource.fetchCategories(),
      trendService.trendingProducts(),
      auctionRepository.fetchAuctions(),
      auctionRepository.fetchDeals(),
    ]);

    categories.assignAll((data[0] as List<dynamic>).map((e) => Category.fromJson(e as Map<String, dynamic>)));
    trendingProducts.assignAll(data[1] as List<Product>);
    auctionItems.assignAll(data[2] as List<Auction>);
    deals.assignAll(data[3] as List<Discount>);
    isLoading.value = false;
  }

  Future<void> filterByCategory(String? categoryId) async {
    selectedCategoryId.value = categoryId;
    isLoading.value = true;
    if (categoryId == null) {
      trendingProducts.assignAll(await trendService.trendingProducts());
    } else {
      trendingProducts.assignAll(await trendService.trendingProducts(categoryId: categoryId));
    }
    isLoading.value = false;
  }

  void changeTab(int index) => currentIndex.value = index;

  void toggleFavorite(Product product) {
    productRepository.toggleFavorite(product.id);
  }
}
