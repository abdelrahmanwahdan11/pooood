class Bid {
  const Bid({
    required this.userId,
    required this.amount,
    required this.placedAt,
  });

  final String userId;
  final double amount;
  final DateTime placedAt;

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'amount': amount,
        'placedAt': placedAt.toIso8601String(),
      };

  factory Bid.fromJson(Map<String, dynamic> json) {
    return Bid(
      userId: json['userId'] as String? ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0,
      placedAt: json['placedAt'] != null
          ? DateTime.tryParse(json['placedAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
