import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

import '../datasources/local/mock_data_provider.dart';
import '../datasources/remote/firestore_ds.dart';
import '../models/wanted_request.dart';

class WantedRepository {
  WantedRepository({
    required this.firestore,
    required this.mockProvider,
  });

  final FirestoreDataSource firestore;
  final MockDataProvider mockProvider;

  Future<List<WantedRequest>> fetchWanted() async {
    try {
      final snapshot = await firestore.getCollection('wanted', (ref) {
        return ref.orderBy('createdAt', descending: true).limit(50);
      });
      return snapshot.docs
          .map((doc) => WantedRequest.fromJson(doc.id, doc.data()))
          .toList();
    } on FirebaseException {
      return _loadMockWanted();
    } on PlatformException {
      return _loadMockWanted();
    }
  }

  Future<List<WantedRequest>> _loadMockWanted() async {
    final list = await mockProvider.loadList('assets/mock/wanted.json');
    return list
        .whereType<Map<String, dynamic>>()
        .map((e) => WantedRequest.fromJson(e['id'] as String, e))
        .toList();
  }

  Future<void> createWanted(WantedRequest request) async {
    // TODO: Wrap in Cloud Function to fan-out FCM alerts based on geohash proximity.
    await firestore.collection('wanted').add(request.toJson());
  }
}
