class Bid {
  Bid({
    required this.id,
    required this.auctionId,
    required this.amount,
    required this.userId,
    required this.placedAt,
  });

  final String id;
  final String auctionId;
  final double amount;
  final String userId;
  final DateTime placedAt;

  factory Bid.fromJson(Map<String, dynamic> json) {
    return Bid(
      id: json['id'] as String,
      auctionId: json['auctionId'] as String,
      amount: (json['amount'] as num).toDouble(),
      userId: json['userId'] as String,
      placedAt: DateTime.parse(json['placedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'auctionId': auctionId,
        'amount': amount,
        'userId': userId,
        'placedAt': placedAt.toIso8601String(),
      };
}
