import 'package:sqflite/sqflite.dart';

import '../db/app_db.dart';
import '../models/price_watch.dart';

class WatchesRepository {
  WatchesRepository({required this.database});

  final AppDatabase database;

  Database get _db => database.db;

  Future<List<PriceWatch>> fetchWatches() async {
    final maps = await _db.query(
      'price_watches',
      orderBy: 'expiryDate ASC',
    );
    return maps.map(PriceWatch.fromMap).toList();
  }

  Future<int> addWatch(PriceWatch watch) async {
    return _db.insert('price_watches', watch.toMap());
  }

  Future<void> updateWatch(PriceWatch watch) async {
    await _db.update(
      'price_watches',
      watch.toMap(),
      where: 'id = ?',
      whereArgs: [watch.id],
    );
  }

  Future<void> deleteWatch(int id) async {
    await _db.delete(
      'price_watches',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
