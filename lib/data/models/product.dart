class Product {
  const Product({
    required this.id,
    required this.title,
    required this.category,
    required this.condition,
    required this.description,
    required this.imageUrls,
  });

  final String id;
  final String title;
  final String category;
  final String condition;
  final String description;
  final List<String> imageUrls;

  factory Product.fromMap(Map<String, dynamic> map, {String? id}) {
    final images = map['imageUrls'] ?? map['images'];
    return Product(
      id: id ?? map['id'] as String? ?? '',
      title: map['title'] as String? ?? '',
      category: map['category'] as String? ?? '',
      condition: map['condition'] as String? ?? '',
      description: map['description'] as String? ?? '',
      imageUrls: images is List
          ? images.map((e) => e.toString()).toList(growable: false)
          : const <String>[],
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'category': category,
        'condition': condition,
        'description': description,
        'imageUrls': imageUrls,
      };
}
