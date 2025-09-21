import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

class StubApiDataSource {
  Future<Map<String, dynamic>> _loadJson(String path) async {
    final data = await rootBundle.loadString(path);
    return jsonDecode(data) as Map<String, dynamic>;
  }

  Future<List<dynamic>> _loadList(String path) async {
    final data = await rootBundle.loadString(path);
    return jsonDecode(data) as List<dynamic>;
  }

  Future<List<dynamic>> fetchTrending() => _loadList('assets/mock/trending.json');

  Future<List<dynamic>> fetchProducts() => _loadList('assets/mock/products.json');

  Future<List<dynamic>> fetchCategories() => _loadList('assets/mock/categories.json');

  Future<List<dynamic>> fetchAuctions() => _loadList('assets/mock/auctions.json');

  Future<List<dynamic>> fetchDiscounts() => _loadList('assets/mock/deals.json');

  Future<List<dynamic>> fetchStores() => _loadList('assets/mock/stores.json');

  Future<List<dynamic>> fetchSearchSuggestions() => _loadList('assets/mock/suggestions.json');

  Future<Map<String, dynamic>> fetchProductDetail(String id) async {
    final products = await fetchProducts();
    final product = products.cast<Map<String, dynamic>>().firstWhere((e) => e['id'] == id);
    return product;
  }
}
