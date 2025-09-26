import 'package:sqflite/sqflite.dart';

import '../db/app_db.dart';
import '../models/discount_deal.dart';

class DiscountsRepository {
  DiscountsRepository({required this.database});

  final AppDatabase database;

  Database get _db => database.db;

  Future<List<DiscountDeal>> fetchDiscounts() async {
    final maps = await _db.query(
      'discounts',
      orderBy: 'distanceKm ASC, discountPercent DESC, validUntil ASC',
    );
    return maps.map(DiscountDeal.fromMap).toList();
  }

  Future<int> addDiscount(DiscountDeal deal) async {
    return _db.insert('discounts', deal.toMap());
  }

  Future<void> updateDiscount(DiscountDeal deal) async {
    await _db.update(
      'discounts',
      deal.toMap(),
      where: 'id = ?',
      whereArgs: [deal.id],
    );
  }

  Future<void> deleteDiscount(int id) async {
    await _db.delete(
      'discounts',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
