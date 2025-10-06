/*
  هذا الملف يُعرّف نموذج العنصر الخاص بالمزادات مع دوال التحويل من وإلى JSON.
  يمكن توسيعه بإضافة خصائص جديدة مثل حالة التسليم أو بيانات البائع مع تحديث الدوال المرافقة.
*/
import 'dart:convert';

class ItemModel {
  final String id;
  final String titleAr;
  final String titleEn;
  final String descriptionAr;
  final String descriptionEn;
  final String category;
  final List<String> images;
  final double startPrice;
  final double currentPrice;
  final bool isAuction;
  final DateTime? endTime;

  const ItemModel({
    required this.id,
    required this.titleAr,
    required this.titleEn,
    required this.descriptionAr,
    required this.descriptionEn,
    required this.category,
    required this.images,
    required this.startPrice,
    required this.currentPrice,
    required this.isAuction,
    this.endTime,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      id: json['id'] as String,
      titleAr: json['title_ar'] as String,
      titleEn: json['title_en'] as String,
      descriptionAr: json['description_ar'] as String,
      descriptionEn: json['description_en'] as String,
      category: json['category'] as String,
      images: List<String>.from(json['images'] ?? const []),
      startPrice: (json['start_price'] as num).toDouble(),
      currentPrice: (json['current_price'] as num).toDouble(),
      isAuction: json['is_auction'] as bool,
      endTime: json['end_time'] != null
          ? DateTime.tryParse(json['end_time'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title_ar': titleAr,
        'title_en': titleEn,
        'description_ar': descriptionAr,
        'description_en': descriptionEn,
        'category': category,
        'images': images,
        'start_price': startPrice,
        'current_price': currentPrice,
        'is_auction': isAuction,
        'end_time': endTime?.toIso8601String(),
      };

  ItemModel copyWith({
    String? id,
    String? titleAr,
    String? titleEn,
    String? descriptionAr,
    String? descriptionEn,
    String? category,
    List<String>? images,
    double? startPrice,
    double? currentPrice,
    bool? isAuction,
    DateTime? endTime,
  }) {
    return ItemModel(
      id: id ?? this.id,
      titleAr: titleAr ?? this.titleAr,
      titleEn: titleEn ?? this.titleEn,
      descriptionAr: descriptionAr ?? this.descriptionAr,
      descriptionEn: descriptionEn ?? this.descriptionEn,
      category: category ?? this.category,
      images: images ?? this.images,
      startPrice: startPrice ?? this.startPrice,
      currentPrice: currentPrice ?? this.currentPrice,
      isAuction: isAuction ?? this.isAuction,
      endTime: endTime ?? this.endTime,
    );
  }

  static List<ItemModel> listFromJsonString(String? source) {
    if (source == null || source.isEmpty) return [];
    final decoded = jsonDecode(source) as List<dynamic>;
    return decoded.map((e) => ItemModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  static String listToJsonString(List<ItemModel> items) {
    final list = items.map((item) => item.toJson()).toList();
    return jsonEncode(list);
  }
}
