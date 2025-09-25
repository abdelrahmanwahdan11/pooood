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
}
