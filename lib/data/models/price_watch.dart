class PriceWatch {
  const PriceWatch({
    required this.id,
    required this.productName,
    required this.targetPrice,
    required this.notes,
    required this.isActive,
  });

  final String id;
  final String productName;
  final double targetPrice;
  final String notes;
  final bool isActive;
}
