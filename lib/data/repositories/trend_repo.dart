import '../datasources/local/get_storage_ds.dart';
import '../datasources/remote/stub_api_ds.dart';
import '../models/product.dart';
import 'product_repo.dart';

class TrendRepository {
  TrendRepository({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  final StubApiDataSource remoteDataSource;
  final GetStorageDataSource localDataSource;

  List<Map<String, dynamic>>? _cachedTrend;

  Future<List<Map<String, dynamic>>> fetchTrend() async {
    if (_cachedTrend != null) return _cachedTrend!;
    final list = await remoteDataSource.fetchTrending();
    _cachedTrend = list.cast<Map<String, dynamic>>();
    return _cachedTrend!;
  }

  Future<List<String>> trendingIds({String? categoryId}) async {
    final trend = await fetchTrend();
    final filtered = categoryId == null
        ? trend
        : trend.where((element) => element['categoryId'] == categoryId).toList();
    return filtered.map((e) => e['productId'] as String).toList();
  }

  Future<double> trendingScore(String productId) async {
    final trend = await fetchTrend();
    final item = trend.firstWhere((e) => e['productId'] == productId, orElse: () => {});
    return (item['score'] as num?)?.toDouble() ?? 0;
  }

  Future<List<Product>> trendingProducts(ProductRepository productRepository, {String? categoryId}) async {
    final trend = await fetchTrend();
    final ids = await trendingIds(categoryId: categoryId);
    final products = await productRepository.getAllProducts();
    final result = products.where((p) => ids.contains(p.id)).map((product) {
      final score = (trend.firstWhere((t) => t['productId'] == product.id)['score'] as num?)?.toDouble() ?? 0;
      return product.copyWith(trendingScore: score);
    }).toList();
    result.sort((a, b) => b.trendingScore.compareTo(a.trendingScore));
    return result;
  }
}
