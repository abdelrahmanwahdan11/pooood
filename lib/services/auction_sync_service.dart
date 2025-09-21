import 'dart:async';

import 'package:get/get.dart';

import '../data/models/auction.dart';
import '../data/repositories/auction_repo.dart';

class AuctionSyncService extends GetxService {
  AuctionSyncService(this._repo);

  final AuctionRepository _repo;
  final _controller = StreamController<List<Auction>>.broadcast();

  Stream<List<Auction>> get stream => _controller.stream;

  Future<AuctionSyncService> init() async {
    final auctions = await _repo.getAuctions();
    _controller.add(auctions);
    return this;
  }

  Future<void> refresh() async {
    final auctions = await _repo.getAuctions();
    _controller.add(auctions);
  }

  @override
  void onClose() {
    _controller.close();
    super.onClose();
  }

  // TODO: Firebase Realtime/Firestore integration
  // 1) Add firebase_core and cloud_firestore packages.
  // 2) Initialize Firebase in main using generated firebase_options.dart.
  // 3) Stream snapshots from `/auctions` collection and `/auctions/{id}/bids`.
  // 4) Apply security rules to enforce bid increments and authenticated access.
  // 5) Implement Cloud Function for anti-sniping extension (extend end time when
  //    bids arrive in the final minute).
  // 6) Map Firestore snapshots to Auction models and push through `_controller`.
}
