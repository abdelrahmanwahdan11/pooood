class FeatureIdea {
  const FeatureIdea({required this.index, required this.textEn, required this.textAr});

  final int index;
  final String textEn;
  final String textAr;

  String text(String localeCode) => localeCode == 'ar' ? textAr : textEn;
}
