/*
  هذا الملف يعرّف نموذج المزايدة مع الوقت والقيم المرتبطة.
  يمكن تطويره لاحقاً بإضافة حالة المزايدة أو مرفقات إضافية.
*/
import 'dart:convert';

class BidModel {
  final String id;
  final String itemId;
  final String userId;
  final double amount;
  final DateTime createdAt;

  const BidModel({
    required this.id,
    required this.itemId,
    required this.userId,
    required this.amount,
    required this.createdAt,
  });

  factory BidModel.fromJson(Map<String, dynamic> json) {
    return BidModel(
      id: json['id'] as String,
      itemId: json['item_id'] as String,
      userId: json['user_id'] as String,
      amount: (json['amount'] as num).toDouble(),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'item_id': itemId,
        'user_id': userId,
        'amount': amount,
        'created_at': createdAt.toIso8601String(),
      };

  static List<BidModel> listFromJsonString(String? source) {
    if (source == null || source.isEmpty) return [];
    final decoded = jsonDecode(source) as List<dynamic>;
    return decoded.map((e) => BidModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  static String listToJsonString(List<BidModel> bids) {
    final list = bids.map((bid) => bid.toJson()).toList();
    return jsonEncode(list);
  }
}
