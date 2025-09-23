import 'dart:async';

import 'package:get/get.dart';

import '../data/models/auction.dart';
import '../data/models/bid.dart';
import '../data/repositories/auction_repo.dart';

class AuctionSyncService extends GetxService {
  AuctionSyncService({required this.auctionRepository});

  final AuctionRepository auctionRepository;
  final Map<String, StreamSubscription<Auction?>> _subscriptions = {};

  void listenToAuction(String auctionId, void Function(Auction? auction) onData) {
    _subscriptions[auctionId]?.cancel();
    _subscriptions[auctionId] =
        auctionRepository.watchAuction(auctionId).listen(onData);
  }

  Future<void> placeBid(String auctionId, double amount, String userId) async {
    final bid = Bid(userId: userId, amount: amount, placedAt: DateTime.now());
    await auctionRepository.placeBid(auctionId: auctionId, bid: bid);
  }

  @override
  void onClose() {
    for (final sub in _subscriptions.values) {
      sub.cancel();
    }
    super.onClose();
  }
}
