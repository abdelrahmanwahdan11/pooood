import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

import '../datasources/local/mock_data_provider.dart';
import '../datasources/remote/firestore_ds.dart';
import '../models/auction.dart';
import '../models/bid.dart';

class AuctionRepository {
  AuctionRepository({
    required this.firestore,
    required this.mockProvider,
  });

  final FirestoreDataSource firestore;
  final MockDataProvider mockProvider;

  Future<List<Auction>> fetchAuctions() async {
    try {
      final snapshot = await firestore.getCollection('auctions', (ref) {
        return ref.orderBy('endsAt').limit(30);
      });
      return snapshot.docs
          .map((doc) => Auction.fromJson(doc.id, doc.data()))
          .toList();
    } on FirebaseException {
      return _loadMockAuctions();
    } on PlatformException {
      return _loadMockAuctions();
    }
  }

  Future<List<Auction>> _loadMockAuctions() async {
    final list = await mockProvider.loadList('assets/mock/auctions.json');
    return list
        .whereType<Map<String, dynamic>>()
        .map((e) => Auction.fromJson(e['id'] as String, e))
        .toList();
  }

  Future<Auction?> fetchAuction(String id) async {
    try {
      final snapshot = await firestore.getDocument('auctions/$id');
      if (!snapshot.exists) return null;
      final data = snapshot.data();
      if (data == null) return null;
      return Auction.fromJson(snapshot.id, data);
    } on FirebaseException {
      final list = await _loadMockAuctions();
      for (final auction in list) {
        if (auction.id == id) {
          return auction;
        }
      }
      return null;
    }
  }

  Future<List<Bid>> fetchBids(String auctionId) async {
    try {
      final snapshot = await firestore.getCollection('auctions/$auctionId/bids', (ref) {
        return ref.orderBy('placedAt', descending: true).limit(50);
      });
      return snapshot.docs.map((doc) => Bid.fromJson(doc.data())).toList();
    } on FirebaseException {
      final bids = await mockProvider.loadList('assets/mock/bids.json');
      return bids
          .whereType<Map<String, dynamic>>()
          .where((element) => element['auctionId'] == auctionId)
          .map(Bid.fromJson)
          .toList();
    }
  }

  Stream<Auction?> watchAuction(String id) {
    return firestore.streamDocument('auctions/$id').map((snapshot) {
      if (!snapshot.exists) return null;
      final data = snapshot.data();
      if (data == null) return null;
      return Auction.fromJson(snapshot.id, data);
    });
  }

  Future<void> placeBid({
    required String auctionId,
    required Bid bid,
  }) async {
    // TODO: Replace with callable Cloud Function to validate minIncrement and anti-sniping logic.
    await firestore
        .collection('auctions/$auctionId/bids')
        .add(bid.toJson());
  }
}
