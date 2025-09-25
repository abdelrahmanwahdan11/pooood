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
}
