import 'package:sqflite/sqflite.dart';

import '../db/app_db.dart';
import '../models/notification_item.dart';

class NotificationsRepository {
  NotificationsRepository({required this.database});

  final AppDatabase database;

  Database get _db => database.db;

  Future<List<NotificationItem>> fetchNotifications() async {
    final maps = await _db.query(
      'notifications',
      orderBy: 'createdAt DESC',
    );
    return maps.map(NotificationItem.fromMap).toList();
  }

  Future<void> markRead(int id, bool read) async {
    await _db.update(
      'notifications',
      {'read': read ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> addNotification(NotificationItem item) async {
    await _db.insert('notifications', item.toMap());
  }
}
