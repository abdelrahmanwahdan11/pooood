class PriceWatch {
  const PriceWatch({
    required this.id,
    required this.productName,
    required this.targetPrice,
    required this.notes,
    required this.isActive,
  });

  final String id;
  final String productName;
  final double targetPrice;
  final String notes;
  final bool isActive;

  factory PriceWatch.fromMap(Map<String, dynamic> map, {String? id}) {
    return PriceWatch(
      id: id ?? map['id'] as String? ?? '',
      productName: map['productName'] as String? ?? '',
      targetPrice: (map['targetPrice'] as num?)?.toDouble() ?? 0,
      notes: map['notes'] as String? ?? '',
      isActive: map['isActive'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'productName': productName,
        'targetPrice': targetPrice,
        'notes': notes,
        'isActive': isActive,
      };
}
