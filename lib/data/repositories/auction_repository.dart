import '../models/auction.dart';
import '../models/geo_point.dart';
import '../models/product.dart';

abstract class AuctionRepository {
  List<Auction> getAuctions();
}

class InMemoryAuctionRepository implements AuctionRepository {
  InMemoryAuctionRepository();

  // Firebase integration placeholder:
  // When ready to connect to Cloud Firestore, replace the in-memory
  // repository with an async implementation similar to the commented code.
  //
  // import 'package:cloud_firestore/cloud_firestore.dart';
  //
  // class FirestoreAuctionRepository implements AuctionRepository {
  //   FirestoreAuctionRepository(this._firestore);
  //
  //   final FirebaseFirestore _firestore;
  //
  //   @override
  //   Future<List<Auction>> getAuctions() async {
  //     final snapshot = await _firestore.collection('auctions').get();
  //     return snapshot.docs
  //         .map((doc) => Auction.fromMap(doc.data(), id: doc.id))
  //         .toList();
  //   }
  // }

  final _products = [
    const Product(
      id: 'p1',
      title: 'كاميرا سوني A7 IV',
      category: 'التصوير',
      condition: 'ممتازة',
      description: 'كاميرا فل فريم مع عدسة 24-70 ملم وملحقات كاملة.',
      imageUrls: [
        'https://images.pexels.com/photos/51383/camera-lens-lens-old-camera-51383.jpeg',
        'https://images.pexels.com/photos/51382/camera-old-antique-51382.jpeg',
      ],
    ),
    const Product(
      id: 'p2',
      title: 'ماكبوك برو 14 بوصة',
      category: 'إلكترونيات',
      condition: 'جديد تقريباً',
      description: 'شريحة M3 برو، 16 جيجابايت رام، 1 تيرابايت SSD.',
      imageUrls: [
        'https://images.pexels.com/photos/18105/pexels-photo.jpg',
        'https://images.pexels.com/photos/694740/pexels-photo-694740.jpeg',
      ],
    ),
  ];

  @override
  List<Auction> getAuctions() {
    final now = DateTime.now();
    return [
      Auction(
        id: 'a1',
        product: _products[0],
        currentBid: 5800,
        startPrice: 4500,
        endTime: now.add(const Duration(hours: 5)),
        location: const GeoPoint(latitude: 24.7136, longitude: 46.6753),
        participants: 12,
      ),
      Auction(
        id: 'a2',
        product: _products[1],
        currentBid: 9100,
        startPrice: 8000,
        endTime: now.add(const Duration(hours: 9)),
        location: const GeoPoint(latitude: 21.4858, longitude: 39.1925),
        participants: 7,
      ),
    ];
  }
}
