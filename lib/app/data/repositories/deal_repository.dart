import 'dart:async';

import '../models/item.dart';
import 'item_repository.dart';

abstract class DealRepository {
  Future<List<Item>> fetchActiveDeals({int page, int limit});
}

class MockDealRepository implements DealRepository {
  MockDealRepository(this._itemRepository);

  final ItemRepository _itemRepository;

  @override
  Future<List<Item>> fetchActiveDeals({int page = 1, int limit = 10}) async {
    final items = await _itemRepository.fetchItems(page: page, limit: limit);
    return items.where((item) => item.discount != null).toList();
  }
}
