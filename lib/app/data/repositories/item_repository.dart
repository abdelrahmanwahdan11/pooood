import 'dart:async';

import '../models/item.dart';

abstract class ItemRepository {
  Future<List<Item>> fetchItems({int page, int limit});
  Future<Item?> findById(String id);
  Future<List<Item>> fetchNearby({required double lat, required double lng, int limit});
}

class MockItemRepository implements ItemRepository {
  MockItemRepository() {
    _items = _seedItems();
  }

  late final List<Item> _items;

  @override
  Future<List<Item>> fetchItems({int page = 1, int limit = 10}) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final start = (page - 1) * limit;
    return _items.skip(start).take(limit).toList();
  }

  @override
  Future<Item?> findById(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    try {
      return _items.firstWhere((item) => item.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<Item>> fetchNearby({required double lat, required double lng, int limit = 10}) async {
    await Future<void>.delayed(const Duration(milliseconds: 180));
    return _items.take(limit).toList();
  }

  List<Item> _seedItems() {
    final now = DateTime.now();
    return [
      Item(
        id: 'itm_001',
        title: 'Vintage Camera',
        images: const [
          'https://images.unsplash.com/photo-1519183071298-a2962be90b8e',
          'https://images.unsplash.com/photo-1526170375885-4d8ecf77b99f',
        ],
        basePrice: 120.0,
        category: 'Electronics',
        country: 'US',
        auction: AuctionInfo(
          endAt: now.add(const Duration(hours: 6)),
          currentPrice: 180.0,
          minStep: 10.0,
          bidCount: 8,
        ),
        discount: null,
        stats: const ItemStats(views: 1200, favorites: 340),
        geo: const ItemGeo(lat: 37.7749, lng: -122.4194),
      ),
      Item(
        id: 'itm_002',
        title: 'Handmade Persian Rug',
        images: const [
          'https://images.unsplash.com/photo-1523381210434-271e8be1f52b',
        ],
        basePrice: 450.0,
        category: 'Home',
        country: 'AE',
        auction: AuctionInfo(
          endAt: now.add(const Duration(hours: 2, minutes: 45)),
          currentPrice: 620.0,
          minStep: 25.0,
          bidCount: 12,
        ),
        discount: DiscountInfo(
          percent: 0.15,
          endsAt: now.add(const Duration(days: 1, hours: 4)),
          originalPrice: 780.0,
        ),
        stats: const ItemStats(views: 980, favorites: 210),
        geo: const ItemGeo(lat: 25.2048, lng: 55.2708),
      ),
      Item(
        id: 'itm_003',
        title: 'Limited Edition Sneakers',
        images: const [
          'https://images.unsplash.com/photo-1526170375885-4d8ecf77b99f',
        ],
        basePrice: 220.0,
        category: 'Fashion',
        country: 'SA',
        auction: null,
        discount: DiscountInfo(
          percent: 0.30,
          endsAt: now.add(const Duration(hours: 12)),
          originalPrice: 310.0,
        ),
        stats: const ItemStats(views: 2200, favorites: 860),
        geo: const ItemGeo(lat: 24.7136, lng: 46.6753),
      ),
    ];
  }
}
