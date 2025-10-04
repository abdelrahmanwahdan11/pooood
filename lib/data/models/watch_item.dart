import 'package:flutter/material.dart';

class WatchItem {
  const WatchItem({
    required this.id,
    required this.name,
    required this.brand,
    required this.price,
    this.oldPrice,
    required this.rating,
    required this.imagePlaceholder,
    required this.colors,
    required this.description,
    required this.highlights,
    required this.specs,
    required this.collection,
    required this.wristSizes,
    this.badge,
    this.badgeColor,
  });

  final int id;
  final String name;
  final String brand;
  final double price;
  final double? oldPrice;
  final double rating;
  final Color imagePlaceholder;
  final List<Color> colors;
  final String description;
  final List<String> highlights;
  final Map<String, String> specs;
  final String collection;
  final List<String> wristSizes;
  final String? badge;
  final Color? badgeColor;

  WatchItem copyWith({
    String? name,
    String? brand,
    double? price,
    double? oldPrice,
    double? rating,
    Color? imagePlaceholder,
    List<Color>? colors,
    String? description,
    List<String>? highlights,
    Map<String, String>? specs,
    String? collection,
    List<String>? wristSizes,
    String? badge,
    Color? badgeColor,
  }) {
    return WatchItem(
      id: id,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      price: price ?? this.price,
      oldPrice: oldPrice ?? this.oldPrice,
      rating: rating ?? this.rating,
      imagePlaceholder: imagePlaceholder ?? this.imagePlaceholder,
      colors: colors ?? this.colors,
      description: description ?? this.description,
      highlights: highlights ?? this.highlights,
      specs: specs ?? this.specs,
      collection: collection ?? this.collection,
      wristSizes: wristSizes ?? this.wristSizes,
      badge: badge ?? this.badge,
      badgeColor: badgeColor ?? this.badgeColor,
    );
  }
}
