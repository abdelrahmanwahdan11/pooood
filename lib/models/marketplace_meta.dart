import 'locale_text.dart';

class CategoryTag {
  const CategoryTag({required this.id, required this.label});

  final String id;
  final LocaleText label;
}

class HighlightMetric {
  const HighlightMetric({required this.label, required this.value});

  final LocaleText label;
  final String value;
}

class PriceBreakdownItem {
  const PriceBreakdownItem({required this.label, required this.value});

  final LocaleText label;
  final String value;
}

class ShippingStep {
  const ShippingStep({required this.label, required this.detail});

  final LocaleText label;
  final LocaleText detail;
}

class QaEntry {
  const QaEntry({required this.question, required this.answer});

  final LocaleText question;
  final LocaleText answer;
}

class ProductMeta {
  const ProductMeta({
    required this.productId,
    required this.vendorId,
    required this.categoryIds,
    required this.tags,
    required this.specLines,
    required this.breakdown,
    required this.shippingSteps,
    required this.qaEntries,
    required this.highlightMetrics,
    required this.sustainabilityScore,
    required this.sustainabilityNote,
    required this.materials,
    required this.accessories,
    required this.guarantee,
  });

  final String productId;
  final String vendorId;
  final List<String> categoryIds;
  final List<LocaleText> tags;
  final List<LocaleText> specLines;
  final List<PriceBreakdownItem> breakdown;
  final List<ShippingStep> shippingSteps;
  final List<QaEntry> qaEntries;
  final List<HighlightMetric> highlightMetrics;
  final double sustainabilityScore;
  final LocaleText sustainabilityNote;
  final List<LocaleText> materials;
  final List<LocaleText> accessories;
  final LocaleText guarantee;
}

class Vendor {
  const Vendor({
    required this.id,
    required this.name,
    required this.location,
    required this.story,
    required this.focusAreas,
    required this.rating,
    required this.since,
    required this.avatarUrl,
  });

  final String id;
  final LocaleText name;
  final LocaleText location;
  final LocaleText story;
  final List<LocaleText> focusAreas;
  final double rating;
  final int since;
  final String avatarUrl;
}

class MarketplaceCollection {
  const MarketplaceCollection({
    required this.id,
    required this.title,
    required this.description,
    required this.productIds,
  });

  final String id;
  final LocaleText title;
  final LocaleText description;
  final List<String> productIds;
}

class MarketplaceStory {
  const MarketplaceStory({required this.quote, required this.author, required this.role});

  final LocaleText quote;
  final LocaleText author;
  final LocaleText role;
}

class MarketplacePolicy {
  const MarketplacePolicy({required this.title, required this.summary});

  final LocaleText title;
  final LocaleText summary;
}

class TrustBadge {
  const TrustBadge({required this.title, required this.description});

  final LocaleText title;
  final LocaleText description;
}

class MarketplaceReport {
  const MarketplaceReport({required this.period, required this.highlight});

  final LocaleText period;
  final LocaleText highlight;
}
