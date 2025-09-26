import '../models/price_watch.dart';

abstract class PriceWatchRepository {
  List<PriceWatch> getWatches();
  void addWatch(PriceWatch watch);
}

class InMemoryPriceWatchRepository implements PriceWatchRepository {
  InMemoryPriceWatchRepository();

  // Firebase integration placeholder:
  // Replace the in-memory store with Firestore collection access as needed.
  //
  // import 'package:cloud_firestore/cloud_firestore.dart';
  //
  // class FirestorePriceWatchRepository implements PriceWatchRepository {
  //   FirestorePriceWatchRepository(this._firestore);
  //
  //   final FirebaseFirestore _firestore;
  //
  //   @override
  //   Future<List<PriceWatch>> getWatches() async {
  //     final snapshot = await _firestore.collection('price_watches').get();
  //     return snapshot.docs
  //         .map((doc) => PriceWatch.fromMap(doc.data(), id: doc.id))
  //         .toList();
  //   }
  //
  //   @override
  //   Future<void> addWatch(PriceWatch watch) {
  //     return _firestore.collection('price_watches').add(watch.toMap());
  //   }
  // }

  final _watches = <PriceWatch>[
    const PriceWatch(
      id: 'pw1',
      productName: 'آيفون 15 برو ماكس',
      targetPrice: 4300,
      notes: 'ألوان تيتانيوم فقط',
      isActive: true,
    ),
    const PriceWatch(
      id: 'pw2',
      productName: 'كرسي ゲーミング',
      targetPrice: 950,
      notes: 'دعم أسفل الظهر',
      isActive: false,
    ),
  ];

  @override
  List<PriceWatch> getWatches() => List.unmodifiable(_watches);

  @override
  void addWatch(PriceWatch watch) => _watches.add(watch);
}
