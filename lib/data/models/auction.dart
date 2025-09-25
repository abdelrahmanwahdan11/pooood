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
