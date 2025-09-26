import 'geo_point.dart';
import 'product.dart';

class DiscountDeal {
  const DiscountDeal({
    required this.id,
    required this.product,
    required this.discountPercent,
    required this.priceAfter,
    required this.storeName,
    required this.expiresAt,
    required this.location,
    required this.distanceKm,
  });

  final String id;
  final Product product;
  final double discountPercent;
  final double priceAfter;
  final String storeName;
  final DateTime expiresAt;
  final GeoPoint location;
  final double distanceKm;

  factory DiscountDeal.fromMap(Map<String, dynamic> map, {String? id}) {
    DateTime parseDate(dynamic value) {
      if (value is DateTime) return value;
      if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
      if (value is num) {
        return DateTime.fromMillisecondsSinceEpoch(value.toInt());
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

    return DiscountDeal(
      id: id ?? map['id'] as String? ?? '',
      product: Product.fromMap(
        (map['product'] as Map<String, dynamic>? ?? const <String, dynamic>{}),
      ),
      discountPercent: (map['discountPercent'] as num?)?.toDouble() ?? 0,
      priceAfter: (map['priceAfter'] as num?)?.toDouble() ?? 0,
      storeName: map['storeName'] as String? ?? '',
      expiresAt: parseDate(map['expiresAt']),
      location: parseLocation(map['location']),
      distanceKm: (map['distanceKm'] as num?)?.toDouble() ?? 0,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'product': product.toMap(),
        'discountPercent': discountPercent,
        'priceAfter': priceAfter,
        'storeName': storeName,
        'expiresAt': expiresAt.toIso8601String(),
        'location': location.toMap(),
        'distanceKm': distanceKm,
      };
}
