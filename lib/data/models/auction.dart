import 'package:intl/intl.dart';

import 'geo_point.dart';
import 'product.dart';

class Auction {
  Auction({
    required this.id,
    required this.product,
    required this.currentBid,
    required this.startPrice,
    required this.endTime,
    required this.location,
    required this.participants,
  });

  final String id;
  final Product product;
  final double currentBid;
  final double startPrice;
  final DateTime endTime;
  final GeoPoint location;
  final int participants;

  factory Auction.fromMap(Map<String, dynamic> map, {String? id}) {
    DateTime parseDate(dynamic value) {
      if (value is DateTime) return value;
      if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
      if (value is num) {
        final intValue = value.toInt();
        return DateTime.fromMillisecondsSinceEpoch(intValue);
      }
      return DateTime.now();
    }

    GeoPoint parseLocation(dynamic value) {
      if (value is GeoPoint) return value;
      if (value is Map<String, dynamic>) {
        return GeoPoint.fromMap(value);
      }
      return const GeoPoint(latitude: 0, longitude: 0);
    }

    return Auction(
      id: id ?? map['id'] as String? ?? '',
      product: Product.fromMap(
        (map['product'] as Map<String, dynamic>? ?? const <String, dynamic>{}),
      ),
      currentBid: (map['currentBid'] as num?)?.toDouble() ?? 0,
      startPrice: (map['startPrice'] as num?)?.toDouble() ?? 0,
      endTime: parseDate(map['endTime']),
      location: parseLocation(map['location']),
      participants: (map['participants'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'product': product.toMap(),
        'currentBid': currentBid,
        'startPrice': startPrice,
        'endTime': endTime.toIso8601String(),
        'location': location.toMap(),
        'participants': participants,
      };

  String get formattedCurrentBid => NumberFormat.currency(symbol: '﷼').format(currentBid);
  Duration get timeLeft => endTime.difference(DateTime.now());

  Auction copyWith({
    double? currentBid,
    int? participants,
  }) {
    return Auction(
      id: id,
      product: product,
      currentBid: currentBid ?? this.currentBid,
      startPrice: startPrice,
      endTime: endTime,
      location: location,
      participants: participants ?? this.participants,
    );
  }
}
