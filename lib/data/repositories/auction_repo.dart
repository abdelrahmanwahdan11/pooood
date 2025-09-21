import '../datasources/local/get_storage_ds.dart';
import '../datasources/remote/stub_api_ds.dart';
import '../models/auction.dart';
import '../models/bid.dart';

class AuctionRepository {
  AuctionRepository(this._remote, this._local);

  final StubApiDataSource _remote;
  final GetStorageDataSource _local;

  final Map<String, List<Bid>> _localBidBuffer = {};
  List<Auction>? _mutableAuctions;

  Future<List<Auction>> getAuctions() async {
    _mutableAuctions ??=
        (await _remote.fetchAuctions()).map((auction) => auction).toList();
    return _mutableAuctions!;
  }

  Future<Auction?> getAuction(String id) async {
    final auctions = await getAuctions();
    try {
      return auctions.firstWhere((element) => element.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<List<Bid>> getBids(String auctionId) async {
    final remoteBids = await _remote.fetchBids(auctionId);
    final localBids = _localBidBuffer[auctionId] ?? <Bid>[];
    final allBids = [...localBids, ...remoteBids];
    allBids.sort((a, b) => b.placedAt.compareTo(a.placedAt));
    return allBids;
  }

  Future<Bid> placeBid({required String auctionId, required double amount}) async {
    final auctions = await getAuctions();
    final index = auctions.indexWhere((element) => element.id == auctionId);
    if (index == -1) {
      throw Exception('Auction not found');
    }
    final auction = auctions[index];
    final updated = auction.copyWith(
      currentBid: amount,
      biddersCount: auction.biddersCount + 1,
    );
    auctions[index] = updated;

    final bid = Bid(
      id: 'local-${DateTime.now().millisecondsSinceEpoch}',
      auctionId: auctionId,
      amount: amount,
      userId: _local.readLocale() ?? 'guest',
      placedAt: DateTime.now(),
    );
    _localBidBuffer.putIfAbsent(auctionId, () => <Bid>[]).insert(0, bid);
    return bid;
  }

  void clearLocalCache() {
    _mutableAuctions = null;
    _localBidBuffer.clear();
  }

  void warmUp() {
    getAuctions();
    _remote.fetchPricingSamples();
  }
}
