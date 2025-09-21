import 'dart:async';

import 'package:get/get.dart';

import '../../core/utils/currency_utils.dart';
import '../../data/models/auction.dart';
import '../../data/models/bid.dart';
import '../../data/repositories/auction_repo.dart';
import '../../services/auction_sync_service.dart';
import '../../services/notification_service.dart';

class AuctionsController extends GetxController {
  AuctionsController(
    this._repo,
    this._syncService,
    this._notifications,
  );

  final AuctionRepository _repo;
  final AuctionSyncService _syncService;
  final NotificationService _notifications;

  final RxList<Auction> auctions = <Auction>[].obs;
  final RxBool isLoading = false.obs;
  final RxnString error = RxnString();
  final Map<String, RxList<Bid>> _bids = {};
  final RxInt visibleCount = 5.obs;

  late final Stream<DateTime> ticker =
      Stream<DateTime>.periodic(const Duration(seconds: 1), (_) => DateTime.now())
          .asBroadcastStream();
  StreamSubscription<List<Auction>>? _syncSubscription;

  // TODO: Firebase Realtime/Firestore live bidding
  // 1) Listen to Firestore snapshots for auctions and bids.
  // 2) Authenticate users with firebase_auth and secure access rules.
  // 3) Enforce bid increments via Firestore security rules.
  // 4) Trigger Cloud Functions for anti-sniping extensions and analytics.
  // 5) Sync local state with remote changes and surface push notifications.
  // TODO: FCM notification when a watched auction is outbid.

  @override
  void onInit() {
    super.onInit();
    fetchAuctions();
    _syncSubscription = _syncService.stream.listen((value) {
      auctions.assignAll(value);
    });
  }

  @override
  void onClose() {
    _syncSubscription?.cancel();
    super.onClose();
  }

  Future<void> fetchAuctions() async {
    try {
      isLoading.value = true;
      final data = await _repo.getAuctions();
      auctions.assignAll(data);
      error.value = null;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshAuctions() async {
    await fetchAuctions();
    await _syncService.refresh();
  }

  List<Auction> get visibleAuctions {
    final int count = visibleCount.value.clamp(0, auctions.length).toInt();
    return auctions.take(count).toList();
  }

  void loadMore() {
    if (visibleCount.value < auctions.length) {
      visibleCount.value += 3;
    }
  }

  RxList<Bid> bidsFor(String auctionId) {
    return _bids.putIfAbsent(auctionId, () => <Bid>[].obs);
  }

  Future<void> loadBids(String auctionId) async {
    final results = await _repo.getBids(auctionId);
    bidsFor(auctionId).assignAll(results);
  }

  Future<Auction?> getAuctionById(String id) async {
    return _repo.getAuction(id);
  }

  Future<void> placeBid({required String auctionId, required double amount}) async {
    await _repo.placeBid(auctionId: auctionId, amount: amount);
    await loadBids(auctionId);
    final updated = await _repo.getAuctions();
    auctions.assignAll(updated);
    await _notifications.showLocalMockNotification(
      title: 'bid_now'.tr,
      body: '${CurrencyUtils.format(amount)} • ${'bid_submitted'.tr}',
    );
    await _syncService.refresh();
  }
}
