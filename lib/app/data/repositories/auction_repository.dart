import 'dart:async';

import '../models/item.dart';
import 'item_repository.dart';

abstract class AuctionRepository {
  Future<List<Item>> fetchActiveAuctions({int page, int limit});
}

class MockAuctionRepository implements AuctionRepository {
  MockAuctionRepository(this._itemRepository);

  final ItemRepository _itemRepository;

  @override
  Future<List<Item>> fetchActiveAuctions({int page = 1, int limit = 10}) async {
    final items = await _itemRepository.fetchItems(page: page, limit: limit);
    return items.where((item) => item.auction != null).toList();
  }
}
