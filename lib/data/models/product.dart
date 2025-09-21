class Product {
  const Product({
    required this.id,
    required this.title,
    required this.brand,
    required this.category,
    required this.images,
    required this.basePrice,
    this.condition,
    this.year,
  });

  final String id;
  final String title;
  final String brand;
  final String category;
  final List<String> images;
  final double basePrice;
  final String? condition;
  final int? year;

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      title: json['title'] as String,
      brand: json['brand'] as String,
      category: json['category'] as String,
      images: (json['images'] as List<dynamic>).cast<String>(),
      basePrice: (json['basePrice'] as num).toDouble(),
      condition: json['condition'] as String?,
      year: json['year'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'brand': brand,
        'category': category,
        'images': images,
        'basePrice': basePrice,
        'condition': condition,
        'year': year,
      };
}
