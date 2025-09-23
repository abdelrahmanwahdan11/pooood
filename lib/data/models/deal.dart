import 'geo_point.dart';

class Deal {
  const Deal({
    required this.id,
    required this.productId,
    required this.discountPct,
    required this.endsAt,
    required this.location,
  });

  final String id;
  final String productId;
  final double discountPct;
  final DateTime endsAt;
  final GeoPointModel location;

  Map<String, dynamic> toJson() => {
        'productId': productId,
        'discountPct': discountPct,
        'endsAt': endsAt.toIso8601String(),
        'location': location.toJson(),
      };

  factory Deal.fromJson(String id, Map<String, dynamic> json) {
    return Deal(
      id: id,
      productId: json['productId'] as String? ?? '',
      discountPct: (json['discountPct'] as num?)?.toDouble() ?? 0,
      endsAt: json['endsAt'] != null
          ? DateTime.tryParse(json['endsAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
      location: GeoPointModel.fromJson(
        (json['location'] as Map<String, dynamic>? ?? {}),
      ),
    );
  }
}
