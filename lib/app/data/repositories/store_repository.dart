import 'dart:async';

import '../models/item.dart';
import '../models/store.dart';

abstract class StoreRepository {
  Future<List<Store>> fetchStores();
}

class MockStoreRepository implements StoreRepository {
  @override
  Future<List<Store>> fetchStores() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return const [
      Store(
        id: 'str_dubai',
        name: 'Dubai Collectibles',
        country: 'AE',
        geo: ItemGeo(lat: 25.2048, lng: 55.2708),
      ),
      Store(
        id: 'str_riyadh',
        name: 'Riyadh Prime Auctions',
        country: 'SA',
        geo: ItemGeo(lat: 24.7136, lng: 46.6753),
      ),
    ];
  }
}
