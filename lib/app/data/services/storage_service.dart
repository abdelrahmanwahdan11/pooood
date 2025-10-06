/*
  هذا الملف يوفّر خدمة التخزين المحلية باستخدام SharedPreferences لكل البيانات الأساسية.
  يمكن توسيعه بإضافة مفاتيح جديدة أو دمج قواعد بيانات أخرى مع الحفاظ على واجهة موحّدة.
*/
import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/bid_model.dart';
import '../models/item_model.dart';
import '../models/user_model.dart';

class StorageService extends GetxService {
  static StorageService get to => Get.find<StorageService>();

  late SharedPreferences _prefs;

  Future<StorageService> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  Future<void> saveUser(UserModel? user) async {
    if (user == null) {
      await _prefs.remove('user');
    } else {
      await _prefs.setString('user', UserModel.toJsonString(user)!);
    }
  }

  UserModel? getUser() {
    return UserModel.fromJsonString(_prefs.getString('user'));
  }

  Future<void> saveFavorites(List<String> favorites) async {
    await _prefs.setStringList('favorites', favorites);
  }

  List<String> getFavorites() {
    return _prefs.getStringList('favorites') ?? <String>[];
  }

  Future<void> saveSettings(Map<String, dynamic> settings) async {
    await _prefs.setString('settings', jsonEncode(settings));
  }

  Map<String, dynamic> getSettings() {
    final data = _prefs.getString('settings');
    if (data == null) return <String, dynamic>{};
    return jsonDecode(data) as Map<String, dynamic>;
  }

  Future<void> saveItems(List<ItemModel> items) async {
    await _prefs.setString('items', ItemModel.listToJsonString(items));
  }

  Future<void> saveItem(ItemModel item) async {
    final items = getItems();
    final index = items.indexWhere((element) => element.id == item.id);
    if (index >= 0) {
      items[index] = item;
    } else {
      items.add(item);
    }
    await saveItems(items);
  }

  List<ItemModel> getItems() {
    return ItemModel.listFromJsonString(_prefs.getString('items'));
  }

  Future<void> saveBids(List<BidModel> bids) async {
    await _prefs.setString('bids', BidModel.listToJsonString(bids));
  }

  List<BidModel> getBids() {
    return BidModel.listFromJsonString(_prefs.getString('bids'));
  }
}
