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
  bool hasCompletedOnboarding = false;
  bool isGuestMode = false;
  String? authToken;
  String? userEmail;
  String? userName;
  String? passwordSignature;
  List<String> _enabledFeatures = [];
  List<int> _favoriteWatchIds = [];
  List<int> _recentlyViewedIds = [];
  List<String> _recentSearches = [];
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
  List<String> get enabledFeatures => List.unmodifiable(_enabledFeatures);
  List<int> get favoriteWatchIds => List.unmodifiable(_favoriteWatchIds);
  List<int> get recentlyViewedIds => List.unmodifiable(_recentlyViewedIds);
  List<String> get recentSearches => List.unmodifiable(_recentSearches);

  Future<void> loadPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    final localeCode = _prefs.getString('locale') ?? 'ar';
    _currentLocale = Locale(localeCode);
    _themeDensity = ThemeDensity.values[
        _prefs.getInt('theme_density') ?? ThemeDensity.cozy.index];
    _distanceUnit = DistanceUnit.values[
        _prefs.getInt('distance_unit') ?? DistanceUnit.kilometers.index];
    _currency = _prefs.getString('currency') ?? 'SAR';
    hasCompletedOnboarding = _prefs.getBool('onboarding_done') ?? false;
    isGuestMode = _prefs.getBool('guest_mode') ?? false;
    authToken = _prefs.getString('auth_token');
    userEmail = _prefs.getString('user_email');
    userName = _prefs.getString('user_name');
    passwordSignature = _prefs.getString('user_password');
    _enabledFeatures = _prefs.getStringList('feature_flags') ?? [];
    _favoriteWatchIds = (_prefs.getStringList('favorite_watch_ids') ?? [])
        .map((value) => int.tryParse(value))
        .whereType<int>()
        .toList();
    _recentlyViewedIds = (_prefs.getStringList('recently_viewed_ids') ?? [])
        .map((value) => int.tryParse(value))
        .whereType<int>()
        .toList();
    _recentSearches = _prefs.getStringList('recent_searches') ?? [];
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

  Future<void> completeOnboarding() async {
    hasCompletedOnboarding = true;
    await _prefs.setBool('onboarding_done', true);
  }

  Future<void> setGuestMode(bool value) async {
    isGuestMode = value;
    await _prefs.setBool('guest_mode', value);
  }

  Future<void> updateAuthSession({
    String? token,
    String? email,
    String? name,
    bool? guestMode,
  }) async {
    authToken = token;
    userEmail = email;
    userName = name;
    if (guestMode != null) {
      isGuestMode = guestMode;
      await _prefs.setBool('guest_mode', guestMode);
    }
    if (token == null) {
      await _prefs.remove('auth_token');
    } else {
      await _prefs.setString('auth_token', token);
    }
    if (email == null) {
      await _prefs.remove('user_email');
    } else {
      await _prefs.setString('user_email', email);
    }
    if (name == null) {
      await _prefs.remove('user_name');
    } else {
      await _prefs.setString('user_name', name);
    }
  }

  Future<void> storeCredentials({
    required String email,
    required String name,
    required String signature,
  }) async {
    userEmail = email;
    userName = name;
    passwordSignature = signature;
    await _prefs.setString('user_email', email);
    await _prefs.setString('user_name', name);
    await _prefs.setString('user_password', signature);
  }

  bool credentialsMatch(String email, String signature) {
    return userEmail == email && passwordSignature == signature;
  }

  Future<void> clearSession() async {
    authToken = null;
    userEmail = null;
    userName = null;
    isGuestMode = false;
    await _prefs.remove('auth_token');
    await _prefs.remove('user_email');
    await _prefs.remove('user_name');
    await _prefs.remove('guest_mode');
  }

  Future<void> persistFeatureFlag(String id, bool enabled) async {
    final flags = _enabledFeatures.toSet();
    if (enabled) {
      flags.add(id);
    } else {
      flags.remove(id);
    }
    _enabledFeatures = flags.toList();
    await _prefs.setStringList('feature_flags', _enabledFeatures);
  }

  Future<void> toggleFavoriteWatch(int id) async {
    final favorites = _favoriteWatchIds.toSet();
    if (favorites.contains(id)) {
      favorites.remove(id);
    } else {
      favorites.add(id);
    }
    _favoriteWatchIds = favorites.toList()..sort();
    await _prefs.setStringList(
      'favorite_watch_ids',
      _favoriteWatchIds.map((e) => e.toString()).toList(),
    );
  }

  Future<void> updateRecentlyViewed(int id) async {
    final viewed = _recentlyViewedIds.toList();
    viewed.remove(id);
    viewed.insert(0, id);
    if (viewed.length > 12) {
      viewed.removeRange(12, viewed.length);
    }
    _recentlyViewedIds = viewed;
    await _prefs.setStringList(
      'recently_viewed_ids',
      _recentlyViewedIds.map((e) => e.toString()).toList(),
    );
  }

  Future<void> addRecentSearch(String query) async {
    final normalized = query.trim();
    if (normalized.isEmpty) return;
    final searches = _recentSearches.toList();
    searches.remove(normalized);
    searches.insert(0, normalized);
    if (searches.length > 10) {
      searches.removeRange(10, searches.length);
    }
    _recentSearches = searches;
    await _prefs.setStringList('recent_searches', _recentSearches);
  }

  Future<void> clearRecentSearches() async {
    _recentSearches = [];
    await _prefs.remove('recent_searches');
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
