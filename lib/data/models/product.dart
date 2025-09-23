import 'geo_point.dart';

class Product {
  const Product({
    required this.id,
    required this.title,
    required this.brand,
    required this.category,
    required this.description,
    required this.images,
    this.videoUrl,
    required this.ownerId,
    required this.basePrice,
    required this.location,
    required this.createdAt,
  });

  final String id;
  final String title;
  final String brand;
  final String category;
  final String description;
  final List<String> images;
  final String? videoUrl;
  final String ownerId;
  final double basePrice;
  final GeoPointModel location;
  final DateTime createdAt;

  Map<String, dynamic> toJson() => {
        'title': title,
        'brand': brand,
        'category': category,
        'description': description,
        'images': images,
        'videoUrl': videoUrl,
        'ownerId': ownerId,
        'basePrice': basePrice,
        'location': location.toJson(),
        'createdAt': createdAt.toIso8601String(),
      };

  factory Product.fromJson(String id, Map<String, dynamic> json) {
    return Product(
      id: id,
      title: json['title'] as String? ?? 'Item',
      brand: json['brand'] as String? ?? 'Brand',
      category: json['category'] as String? ?? 'General',
      description: json['description'] as String? ?? '',
      images: (json['images'] as List<dynamic>? ?? []).cast<String>(),
      videoUrl: json['videoUrl'] as String?,
      ownerId: json['ownerId'] as String? ?? '',
      basePrice: (json['basePrice'] as num?)?.toDouble() ?? 0,
      location: GeoPointModel.fromJson(
        (json['location'] as Map<String, dynamic>? ?? {}),
      ),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
