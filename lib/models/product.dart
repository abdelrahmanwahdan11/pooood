import 'package:flutter/material.dart';

class Product {
  const Product({
    required this.id,
    required this.heroTag,
    required this.nameEn,
    required this.nameAr,
    required this.descriptionEn,
    required this.descriptionAr,
    required this.price,
    required this.featuresEn,
    required this.featuresAr,
    required this.imageUrls,
    required this.initialRating,
    required this.accentColor,
  });

  final String id;
  final String heroTag;
  final String nameEn;
  final String nameAr;
  final String descriptionEn;
  final String descriptionAr;
  final double price;
  final List<String> featuresEn;
  final List<String> featuresAr;
  final List<String> imageUrls;
  final double initialRating;
  final Color accentColor;

  String name(Locale locale) => locale.languageCode == 'ar' ? nameAr : nameEn;
  String description(Locale locale) => locale.languageCode == 'ar' ? descriptionAr : descriptionEn;
  List<String> features(Locale locale) => locale.languageCode == 'ar' ? featuresAr : featuresEn;
}
