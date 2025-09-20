class AuctionInfo {
  AuctionInfo({
    required this.endAt,
    required this.currentPrice,
    required this.minStep,
    this.bidCount = 0,
  });

  final DateTime endAt;
  final double currentPrice;
  final double minStep;
  final int bidCount;
}

class DiscountInfo {
  DiscountInfo({
    required this.percent,
    required this.endsAt,
    this.originalPrice,
  });

  final double percent;
  final DateTime endsAt;
  final double? originalPrice;
}

class ItemStats {
  const ItemStats({
    this.views = 0,
    this.favorites = 0,
  });

  final int views;
  final int favorites;
}

class ItemGeo {
  const ItemGeo({
    required this.lat,
    required this.lng,
  });

  final double lat;
  final double lng;
}

class Item {
  Item({
    required this.id,
    required this.title,
    required this.images,
    required this.basePrice,
    required this.category,
    required this.country,
    this.auction,
    this.discount,
    this.stats = const ItemStats(),
    required this.geo,
  });

  final String id;
  final String title;
  final List<String> images;
  final double basePrice;
  final String category;
  final String country;
  final AuctionInfo? auction;
  final DiscountInfo? discount;
  final ItemStats stats;
  final ItemGeo geo;

  bool get hasAuction => auction != null;
  bool get hasDiscount => discount != null;
}
