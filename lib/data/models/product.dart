class Product {
  const Product({
    required this.id,
    required this.title,
    required this.category,
    required this.condition,
    required this.images,
    required this.location,
    required this.description,
  });

  final int id;
  final String title;
  final String category;
  final String condition;
  final List<String> images;
  final String location;
  final String description;

  Product copyWith({
    String? title,
    String? category,
    String? condition,
    List<String>? images,
    String? location,
    String? description,
  }) {
    return Product(
      id: id,
      title: title ?? this.title,
      category: category ?? this.category,
      condition: condition ?? this.condition,
      images: images ?? this.images,
      location: location ?? this.location,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'category': category,
        'condition': condition,
        'images': images.join('|'),
        'location': location,
        'description': description,
      };

  static Product fromMap(Map<String, dynamic> map) => Product(
        id: map['id'] as int,
        title: map['title'] as String,
        category: map['category'] as String,
        condition: map['condition'] as String,
        images: (map['images'] as String).split('|'),
        location: map['location'] as String,
        description: map['description'] as String,
      );
}
