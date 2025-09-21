import '../datasources/local/get_storage_ds.dart';
import '../datasources/remote/stub_api_ds.dart';
import '../models/auction.dart';
import '../models/discount.dart';

class AuctionRepository {
  AuctionRepository({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  final StubApiDataSource remoteDataSource;
  final GetStorageDataSource localDataSource;

  List<Auction>? _cachedAuctions;
  List<Discount>? _cachedDeals;

  Future<List<Auction>> fetchAuctions() async {
    if (_cachedAuctions != null) return _cachedAuctions!;
    final list = await remoteDataSource.fetchAuctions();
    _cachedAuctions = list.map((e) => Auction.fromJson(e as Map<String, dynamic>)).toList();
    return _cachedAuctions!;
  }

  Future<List<Discount>> fetchDeals() async {
    if (_cachedDeals != null) return _cachedDeals!;
    final list = await remoteDataSource.fetchDiscounts();
    _cachedDeals = list.map((e) => Discount.fromJson(e as Map<String, dynamic>)).toList();
    return _cachedDeals!;
  }
}
