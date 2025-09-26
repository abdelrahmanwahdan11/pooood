import 'package:sqflite/sqflite.dart';

import '../db/app_db.dart';
import '../models/auction.dart';
import '../models/product.dart';

class AuctionsRepository {
  AuctionsRepository({required this.database});

  final AppDatabase database;

  Database get _db => database.db;

  Future<List<Auction>> fetchAuctions() async {
    final maps = await _db.query(
      'auctions',
      orderBy: 'distanceKm ASC, endTime ASC',
    );
    return maps.map(Auction.fromMap).toList();
  }

  Future<Map<int, Product>> fetchProductsForAuctions(
      Iterable<int> productIds) async {
    if (productIds.isEmpty) return {};
    final maps = await _db.query(
      'products',
      where: 'id IN (${List.filled(productIds.length, '?').join(',')})',
      whereArgs: productIds.toList(),
    );
    return {for (final map in maps) map['id'] as int: Product.fromMap(map)};
  }

  Future<void> placeBid(int auctionId, double amount) async {
    final map = await _db.query(
      'auctions',
      where: 'id = ?',
      whereArgs: [auctionId],
      limit: 1,
    );
    if (map.isEmpty) return;
    final auction = Auction.fromMap(map.first);
    final updated = auction.copyWith(
      currentPrice: amount,
      watchers: auction.watchers + 1,
      views: auction.views + 5,
    );
    await _db.update(
      'auctions',
      updated.toMap(),
      where: 'id = ?',
      whereArgs: [auctionId],
    );
  }

  Future<void> toggleFavorite(int auctionId, bool favorite) async {
    await _db.update(
      'auctions',
      {'isFavorite': favorite ? 1 : 0},
      where: 'id = ?',
      whereArgs: [auctionId],
    );
  }
}
