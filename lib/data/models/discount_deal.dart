class DiscountDeal {
  const DiscountDeal({
    required this.id,
    required this.storeName,
    required this.product,
    required this.category,
    required this.discountPercent,
    required this.originalPrice,
    required this.distanceKm,
    required this.location,
    required this.validFrom,
    required this.validUntil,
    required this.terms,
    required this.images,
    required this.ownerId,
  });

  final int id;
  final String storeName;
  final String product;
  final String category;
  final double discountPercent;
  final double originalPrice;
  final double distanceKm;
  final String location;
  final DateTime validFrom;
  final DateTime validUntil;
  final String terms;
  final List<String> images;
  final int ownerId;

  double get discountedPrice => originalPrice * (1 - discountPercent / 100);

  Map<String, dynamic> toMap() => {
        'id': id,
        'storeName': storeName,
        'product': product,
        'category': category,
        'discountPercent': discountPercent,
        'originalPrice': originalPrice,
        'distanceKm': distanceKm,
        'location': location,
        'validFrom': validFrom.millisecondsSinceEpoch,
        'validUntil': validUntil.millisecondsSinceEpoch,
        'terms': terms,
        'images': images.join('|'),
        'ownerId': ownerId,
      };

  static DiscountDeal fromMap(Map<String, dynamic> map) => DiscountDeal(
        id: map['id'] as int,
        storeName: map['storeName'] as String,
        product: map['product'] as String,
        category: map['category'] as String,
        discountPercent: (map['discountPercent'] as num).toDouble(),
        originalPrice: (map['originalPrice'] as num).toDouble(),
        distanceKm: (map['distanceKm'] as num).toDouble(),
        location: map['location'] as String,
        validFrom:
            DateTime.fromMillisecondsSinceEpoch(map['validFrom'] as int),
        validUntil:
            DateTime.fromMillisecondsSinceEpoch(map['validUntil'] as int),
        terms: map['terms'] as String,
        images: (map['images'] as String).split('|'),
        ownerId: map['ownerId'] as int,
      );
}
