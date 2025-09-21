class Discount {
  Discount({
    required this.id,
    required this.productId,
    required this.discountPct,
    required this.endAt,
    this.region = 'global',
  });

  final String id;
  final String productId;
  final double discountPct;
  final DateTime endAt;
  final String region;

  factory Discount.fromJson(Map<String, dynamic> json) {
    return Discount(
      id: json['id'] as String,
      productId: json['productId'] as String,
      discountPct: (json['discountPct'] as num).toDouble(),
      endAt: DateTime.parse(json['endAt'] as String),
      region: json['region'] as String? ?? 'global',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'productId': productId,
        'discountPct': discountPct,
        'endAt': endAt.toIso8601String(),
        'region': region,
      };
}
