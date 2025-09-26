import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../db/app_db.dart';
import '../models/user.dart';
import '../../core/theme/app_theme.dart';

class SettingsRepository {
  SettingsRepository({required this.database});

  final AppDatabase database;

  late SharedPreferences _prefs;
  late Locale _currentLocale;
  late ThemeDensity _themeDensity;
  late DistanceUnit _distanceUnit;
  late String _currency;
  bool notificationsBids = true;
  bool notificationsMatches = true;
  bool notificationsDiscounts = true;
  bool privacyVisible = true;
  bool pinEnabled = false;
  bool biometricEnabled = false;

  Locale get currentLocale => _currentLocale;
  ThemeDensity get themeDensity => _themeDensity;
  DistanceUnit get distanceUnit => _distanceUnit;
  String get currency => _currency;

  Future<void> loadPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    final localeCode = _prefs.getString('locale') ?? 'ar';
    _currentLocale = Locale(localeCode);
    _themeDensity = ThemeDensity.values[
        _prefs.getInt('theme_density') ?? ThemeDensity.cozy.index];
    _distanceUnit = DistanceUnit.values[
        _prefs.getInt('distance_unit') ?? DistanceUnit.kilometers.index];
    _currency = _prefs.getString('currency') ?? 'SAR';
    notificationsBids = _prefs.getBool('notif_bids') ?? true;
    notificationsMatches = _prefs.getBool('notif_matches') ?? true;
    notificationsDiscounts = _prefs.getBool('notif_discounts') ?? true;
    privacyVisible = _prefs.getBool('privacy_visible') ?? true;
    pinEnabled = _prefs.getBool('pin_enabled') ?? false;
    biometricEnabled = _prefs.getBool('bio_enabled') ?? false;
  }

  Future<void> updateLocale(Locale locale) async {
    _currentLocale = locale;
    await _prefs.setString('locale', locale.languageCode);
  }

  Future<void> updateThemeDensity(ThemeDensity density) async {
    _themeDensity = density;
    await _prefs.setInt('theme_density', density.index);
  }

  Future<void> updateDistanceUnit(DistanceUnit unit) async {
    _distanceUnit = unit;
    await _prefs.setInt('distance_unit', unit.index);
  }

  Future<void> updateCurrency(String value) async {
    _currency = value;
    await _prefs.setString('currency', value);
  }

  Future<User> fetchUser() async {
    final maps = await database.db.query(
      'users',
      where: 'id = ?',
      whereArgs: const [1],
      limit: 1,
    );
    return User.fromMap(maps.first);
  }

  Future<void> saveUser(User user) async {
    await database.db.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  Future<void> updateNotificationSettings({
    bool? bids,
    bool? matches,
    bool? discounts,
  }) async {
    notificationsBids = bids ?? notificationsBids;
    notificationsMatches = matches ?? notificationsMatches;
    notificationsDiscounts = discounts ?? notificationsDiscounts;
    await _prefs.setBool('notif_bids', notificationsBids);
    await _prefs.setBool('notif_matches', notificationsMatches);
    await _prefs.setBool('notif_discounts', notificationsDiscounts);
  }

  Future<void> updateSecurity({bool? pin, bool? biometric}) async {
    pinEnabled = pin ?? pinEnabled;
    biometricEnabled = biometric ?? biometricEnabled;
    await _prefs.setBool('pin_enabled', pinEnabled);
    await _prefs.setBool('bio_enabled', biometricEnabled);
  }

  Future<void> updatePrivacy({bool? visible}) async {
    privacyVisible = visible ?? privacyVisible;
    await _prefs.setBool('privacy_visible', privacyVisible);
  }

  Future<Map<String, dynamic>> exportData() async {
    final auctions = await database.db.query('auctions');
    final discounts = await database.db.query('discounts');
    final watches = await database.db.query('price_watches');
    final notifications = await database.db.query('notifications');
    return {
      'auctions': auctions,
      'discounts': discounts,
      'watches': watches,
      'notifications': notifications,
    };
  }

  Future<void> importData(Map<String, dynamic> data) async {
    final batch = database.db.batch();
    if (data['auctions'] case List list) {
      for (final item in list) {
        batch.insert('auctions', Map<String, dynamic>.from(item),
            conflictAlgorithm: ConflictAlgorithm.replace);
      }
    }
    if (data['discounts'] case List list) {
      for (final item in list) {
        batch.insert('discounts', Map<String, dynamic>.from(item),
            conflictAlgorithm: ConflictAlgorithm.replace);
      }
    }
    if (data['watches'] case List list) {
      for (final item in list) {
        batch.insert('price_watches', Map<String, dynamic>.from(item),
            conflictAlgorithm: ConflictAlgorithm.replace);
      }
    }
    if (data['notifications'] case List list) {
      for (final item in list) {
        batch.insert('notifications', Map<String, dynamic>.from(item),
            conflictAlgorithm: ConflictAlgorithm.replace);
      }
    }
    await batch.commit(noResult: true);
  }
}

enum DistanceUnit { kilometers, miles }
