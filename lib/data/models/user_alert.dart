class UserAlert {
  UserAlert({
    required this.id,
    required this.productId,
    required this.targetPrice,
    required this.isActive,
  });

  final String id;
  final String productId;
  final double targetPrice;
  final bool isActive;

  factory UserAlert.fromJson(Map<String, dynamic> json) {
    return UserAlert(
      id: json['id'] as String,
      productId: json['productId'] as String,
      targetPrice: (json['targetPrice'] as num).toDouble(),
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'productId': productId,
        'targetPrice': targetPrice,
        'isActive': isActive,
      };
}
