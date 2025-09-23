import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

import '../datasources/local/mock_data_provider.dart';
import '../datasources/remote/firestore_ds.dart';
import '../models/deal.dart';

class DealRepository {
  DealRepository({
    required this.firestore,
    required this.mockProvider,
  });

  final FirestoreDataSource firestore;
  final MockDataProvider mockProvider;

  Future<List<Deal>> fetchDeals() async {
    try {
      final snapshot = await firestore.getCollection('deals', (ref) {
        return ref.orderBy('endsAt').limit(30);
      });
      return snapshot.docs
          .map((doc) => Deal.fromJson(doc.id, doc.data()))
          .toList();
    } on FirebaseException {
      return _loadMockDeals();
    } on PlatformException {
      return _loadMockDeals();
    }
  }

  Future<List<Deal>> _loadMockDeals() async {
    final list = await mockProvider.loadList('assets/mock/deals.json');
    return list
        .whereType<Map<String, dynamic>>()
        .map((e) => Deal.fromJson(e['id'] as String, e))
        .toList();
  }
}
