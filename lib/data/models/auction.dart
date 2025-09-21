class Auction {
  Auction({
    required this.id,
    required this.productId,
    required this.currentBid,
    required this.endAt,
    required this.biddersCount,
    this.history = const [],
  });

  final String id;
  final String productId;
  final double currentBid;
  final DateTime endAt;
  final int biddersCount;
  final List<Map<String, dynamic>> history;

  factory Auction.fromJson(Map<String, dynamic> json) {
    return Auction(
      id: json['id'] as String,
      productId: json['productId'] as String,
      currentBid: (json['currentBid'] as num).toDouble(),
      endAt: DateTime.parse(json['endAt'] as String),
      biddersCount: json['biddersCount'] as int,
      history: (json['history'] as List<dynamic>?)?.cast<Map<String, dynamic>>() ?? const [],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'productId': productId,
        'currentBid': currentBid,
        'endAt': endAt.toIso8601String(),
        'biddersCount': biddersCount,
        'history': history,
      };
}
