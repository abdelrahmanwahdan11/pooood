import 'product.dart';

class Auction {
  Auction({
    required this.id,
    required this.productId,
    required this.title,
    required this.images,
    required this.currentBid,
    required this.minIncrement,
    required this.biddersCount,
    required this.endAt,
    required this.description,
    this.product,
  });

  final String id;
  final String productId;
  final String title;
  final List<String> images;
  final double currentBid;
  final double minIncrement;
  final int biddersCount;
  final DateTime endAt;
  final String description;
  final Product? product;

  bool get isActive => DateTime.now().isBefore(endAt);

  Auction copyWith({
    double? currentBid,
    double? minIncrement,
    int? biddersCount,
    DateTime? endAt,
    Product? product,
    String? description,
  }) {
    return Auction(
      id: id,
      productId: productId,
      title: title,
      images: images,
      currentBid: currentBid ?? this.currentBid,
      minIncrement: minIncrement ?? this.minIncrement,
      biddersCount: biddersCount ?? this.biddersCount,
      endAt: endAt ?? this.endAt,
      description: description ?? this.description,
      product: product ?? this.product,
    );
  }

  factory Auction.fromJson(Map<String, dynamic> json) {
    return Auction(
      id: json['id'] as String,
      productId: json['productId'] as String,
      title: json['title'] as String,
      images: (json['images'] as List<dynamic>).cast<String>(),
      currentBid: (json['currentBid'] as num).toDouble(),
      minIncrement: (json['minIncrement'] as num).toDouble(),
      biddersCount: json['biddersCount'] as int,
      endAt: DateTime.parse(json['endAt'] as String),
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'productId': productId,
        'title': title,
        'images': images,
        'currentBid': currentBid,
        'minIncrement': minIncrement,
        'biddersCount': biddersCount,
        'endAt': endAt.toIso8601String(),
        'description': description,
      };
}
