import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

import '../datasources/local/mock_data_provider.dart';
import '../datasources/remote/firestore_ds.dart';
import '../models/product.dart';

class ProductRepository {
  ProductRepository({
    required this.firestore,
    required this.mockProvider,
  });

  final FirestoreDataSource firestore;
  final MockDataProvider mockProvider;

  Future<Product?> fetchProduct(String id) async {
    try {
      final snapshot = await firestore.getDocument('products/$id');
      if (!snapshot.exists) return null;
      final data = snapshot.data();
      if (data == null) return null;
      return Product.fromJson(snapshot.id, data);
    } on FirebaseException {
      return _loadMockProduct(id);
    }
  }

  Future<List<Product>> fetchProducts({int limit = 30}) async {
    try {
      final snapshot = await firestore.getCollection('products', (ref) {
        return ref.orderBy('createdAt', descending: true).limit(limit);
      });
      return snapshot.docs
          .map((doc) => Product.fromJson(doc.id, doc.data()))
          .toList();
    } on FirebaseException {
      return _loadMockProducts();
    } on PlatformException {
      return _loadMockProducts();
    }
  }

  Future<List<Product>> _loadMockProducts() async {
    final list = await mockProvider.loadList('assets/mock/products.json');
    return list
        .whereType<Map<String, dynamic>>()
        .map((e) => Product.fromJson(e['id'] as String, e))
        .toList();
  }

  Future<Product?> _loadMockProduct(String id) async {
    final list = await _loadMockProducts();
    if (list.isEmpty) return null;
    return list.firstWhere(
      (element) => element.id == id,
      orElse: () => list.first,
    );
  }
}
