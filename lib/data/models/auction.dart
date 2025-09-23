import 'package:collection/collection.dart';

import 'bid.dart';

class Auction {
  const Auction({
    required this.id,
    required this.productId,
    required this.currentBid,
    required this.minIncrement,
    required this.watchersCount,
    required this.endsAt,
    required this.status,
    required this.createdAt,
    this.biddersCount = 0,
    this.bids = const [],
  });

  final String id;
  final String productId;
  final double currentBid;
  final double minIncrement;
  final int watchersCount;
  final int biddersCount;
  final DateTime endsAt;
  final String status;
  final DateTime createdAt;
  final List<Bid> bids;

  bool get isActive => status == 'active' && DateTime.now().isBefore(endsAt);

  Bid? get lastBid => bids.sortedBy<num>((bid) => bid.amount).lastOrNull;

  Auction copyWith({
    double? currentBid,
    int? watchersCount,
    DateTime? endsAt,
    String? status,
    List<Bid>? bids,
    int? biddersCount,
  }) {
    return Auction(
      id: id,
      productId: productId,
      currentBid: currentBid ?? this.currentBid,
      minIncrement: minIncrement,
      watchersCount: watchersCount ?? this.watchersCount,
      endsAt: endsAt ?? this.endsAt,
      status: status ?? this.status,
      createdAt: createdAt,
      bids: bids ?? this.bids,
      biddersCount: biddersCount ?? this.biddersCount,
    );
  }

  Map<String, dynamic> toJson() => {
        'productId': productId,
        'currentBid': currentBid,
        'minIncrement': minIncrement,
        'watchersCount': watchersCount,
        'biddersCount': biddersCount,
        'endsAt': endsAt.toIso8601String(),
        'status': status,
        'createdAt': createdAt.toIso8601String(),
      };

  factory Auction.fromJson(String id, Map<String, dynamic> json) {
    return Auction(
      id: id,
      productId: json['productId'] as String? ?? '',
      currentBid: (json['currentBid'] as num?)?.toDouble() ?? 0,
      minIncrement: (json['minIncrement'] as num?)?.toDouble() ?? 10,
      watchersCount: json['watchersCount'] as int? ?? 0,
      biddersCount: json['biddersCount'] as int? ?? 0,
      endsAt: json['endsAt'] != null
          ? DateTime.tryParse(json['endsAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
      status: json['status'] as String? ?? 'active',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
      bids: (json['bids'] as List<dynamic>? ?? [])
          .map((e) => Bid.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
