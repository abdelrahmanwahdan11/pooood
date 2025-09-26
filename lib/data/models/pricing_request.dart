class PricingRequest {
  const PricingRequest({
    required this.id,
    required this.productName,
    required this.condition,
    required this.estimatedPrice,
    required this.recommendedTime,
    required this.recommendedArea,
  });

  final String id;
  final String productName;
  final String condition;
  final double estimatedPrice;
  final String recommendedTime;
  final String recommendedArea;

  factory PricingRequest.fromMap(Map<String, dynamic> map, {String? id}) {
    return PricingRequest(
      id: id ?? map['id'] as String? ?? '',
      productName: map['productName'] as String? ?? '',
      condition: map['condition'] as String? ?? '',
      estimatedPrice: (map['estimatedPrice'] as num?)?.toDouble() ?? 0,
      recommendedTime: map['recommendedTime'] as String? ?? '',
      recommendedArea: map['recommendedArea'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'productName': productName,
        'condition': condition,
        'estimatedPrice': estimatedPrice,
        'recommendedTime': recommendedTime,
        'recommendedArea': recommendedArea,
      };
}
