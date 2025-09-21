import '../datasources/local/get_storage_ds.dart';
import '../datasources/remote/stub_api_ds.dart';
import '../models/store_location.dart';

class LocationRepository {
  LocationRepository({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  final StubApiDataSource remoteDataSource;
  final GetStorageDataSource localDataSource;

  List<StoreLocation>? _cachedStores;

  Future<List<StoreLocation>> fetchStores() async {
    if (_cachedStores != null) return _cachedStores!;
    final list = await remoteDataSource.fetchStores();
    _cachedStores = list.map((e) => StoreLocation.fromJson(e as Map<String, dynamic>)).toList();
    return _cachedStores!;
  }
}
