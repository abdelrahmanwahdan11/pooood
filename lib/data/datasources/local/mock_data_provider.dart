import 'dart:convert';

import 'package:flutter/services.dart';

class MockDataProvider {
  const MockDataProvider();

  Future<List<dynamic>> loadList(String assetPath) async {
    final jsonString = await rootBundle.loadString(assetPath);
    final data = json.decode(jsonString);
    if (data is List) {
      return data;
    }
    return [];
  }

  Future<Map<String, dynamic>> loadMap(String assetPath) async {
    final jsonString = await rootBundle.loadString(assetPath);
    final data = json.decode(jsonString);
    if (data is Map<String, dynamic>) {
      return data;
    }
    return {};
  }
}
