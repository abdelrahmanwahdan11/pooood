class Auction {
  const Auction({
    required this.id,
    required this.productId,
    required this.sellerName,
    required this.sellerArea,
    required this.distanceKm,
    required this.currentPrice,
    required this.minIncrement,
    required this.watchers,
    required this.views,
    required this.startTime,
    required this.endTime,
    required this.ownerId,
    required this.isFavorite,
  });

  final int id;
  final int productId;
  final String sellerName;
  final String sellerArea;
  final double distanceKm;
  final double currentPrice;
  final double minIncrement;
  final int watchers;
  final int views;
  final DateTime startTime;
  final DateTime endTime;
  final int ownerId;
  final bool isFavorite;

  Auction copyWith({
    double? currentPrice,
    double? minIncrement,
    int? watchers,
    int? views,
    DateTime? startTime,
    DateTime? endTime,
    bool? isFavorite,
  }) {
    return Auction(
      id: id,
      productId: productId,
      sellerName: sellerName,
      sellerArea: sellerArea,
      distanceKm: distanceKm,
      currentPrice: currentPrice ?? this.currentPrice,
      minIncrement: minIncrement ?? this.minIncrement,
      watchers: watchers ?? this.watchers,
      views: views ?? this.views,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      ownerId: ownerId,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'productId': productId,
        'sellerName': sellerName,
        'sellerArea': sellerArea,
        'distanceKm': distanceKm,
        'currentPrice': currentPrice,
        'minIncrement': minIncrement,
        'watchers': watchers,
        'views': views,
        'startTime': startTime.millisecondsSinceEpoch,
        'endTime': endTime.millisecondsSinceEpoch,
        'ownerId': ownerId,
        'isFavorite': isFavorite ? 1 : 0,
      };

  static Auction fromMap(Map<String, dynamic> map) => Auction(
        id: map['id'] as int,
        productId: map['productId'] as int,
        sellerName: map['sellerName'] as String,
        sellerArea: map['sellerArea'] as String,
        distanceKm: (map['distanceKm'] as num).toDouble(),
        currentPrice: (map['currentPrice'] as num).toDouble(),
        minIncrement: (map['minIncrement'] as num).toDouble(),
        watchers: map['watchers'] as int,
        views: map['views'] as int,
        startTime:
            DateTime.fromMillisecondsSinceEpoch(map['startTime'] as int),
        endTime: DateTime.fromMillisecondsSinceEpoch(map['endTime'] as int),
        ownerId: map['ownerId'] as int,
        isFavorite: (map['isFavorite'] as int) == 1,
      );
}
