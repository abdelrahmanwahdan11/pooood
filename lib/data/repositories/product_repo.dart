import 'package:get/get.dart';

import '../datasources/local/get_storage_ds.dart';
import '../datasources/remote/stub_api_ds.dart';
import '../models/product.dart';

class ProductRepository {
  ProductRepository({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  final StubApiDataSource remoteDataSource;
  final GetStorageDataSource localDataSource;

  List<Product>? _cachedProducts;

  Future<List<Product>> getAllProducts() async {
    if (_cachedProducts != null) return _cachedProducts!;
    final list = await remoteDataSource.fetchProducts();
    _cachedProducts = list.map((e) => Product.fromJson(e as Map<String, dynamic>)).toList();
    return _cachedProducts!;
  }

  Future<Product> getProductById(String id) async {
    final cached = _cachedProducts;
    if (cached != null) {
      final product = cached.firstWhereOrNull((element) => element.id == id);
      if (product != null) return product;
    }
    final json = await remoteDataSource.fetchProductDetail(id);
    return Product.fromJson(json);
  }

  Future<List<Product>> searchProducts(String query) async {
    final products = await getAllProducts();
    final q = query.toLowerCase();
    return products
        .where((p) => p.title.toLowerCase().contains(q) || p.brand.toLowerCase().contains(q))
        .toList();
  }

  Future<List<Product>> favorites() async {
    final products = await getAllProducts();
    final favIds = localDataSource.favorites;
    return products.where((p) => favIds.contains(p.id)).toList();
  }

  void toggleFavorite(String productId) => localDataSource.toggleFavorite(productId);
}
