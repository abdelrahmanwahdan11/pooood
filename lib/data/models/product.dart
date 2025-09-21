import 'store_location.dart';

class Product {
  Product({
    required this.id,
    required this.title,
    required this.brand,
    required this.categoryId,
    required this.images,
    required this.priceApprox,
    required this.rating,
    required this.locations,
    this.trendingScore = 0,
  });

  final String id;
  final String title;
  final String brand;
  final String categoryId;
  final List<String> images;
  final double priceApprox;
  final double rating;
  final List<StoreLocation> locations;
  final double trendingScore;

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      title: json['title'] as String,
      brand: json['brand'] as String,
      categoryId: json['categoryId'] as String,
      images: (json['images'] as List<dynamic>).cast<String>(),
      priceApprox: (json['priceApprox'] as num).toDouble(),
      rating: (json['rating'] as num).toDouble(),
      trendingScore: (json['trendingScore'] as num?)?.toDouble() ?? 0,
      locations: (json['locations'] as List<dynamic>?)
              ?.map((e) => StoreLocation.fromJson(e as Map<String, dynamic>))
              .toList() ??
          <StoreLocation>[],
    );
  }

  Product copyWith({double? trendingScore}) {
    return Product(
      id: id,
      title: title,
      brand: brand,
      categoryId: categoryId,
      images: images,
      priceApprox: priceApprox,
      rating: rating,
      locations: locations,
      trendingScore: trendingScore ?? this.trendingScore,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'brand': brand,
        'categoryId': categoryId,
        'images': images,
        'priceApprox': priceApprox,
        'rating': rating,
        'trendingScore': trendingScore,
        'locations': locations.map((e) => e.toJson()).toList(),
      };
}
