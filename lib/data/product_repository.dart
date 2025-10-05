import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/feature_idea.dart';
import '../models/product.dart';

class ProductRepository {
  static List<Product> _cache = [];

  static Future<List<Product>> fetchPage({required int page, required int pageSize}) async {
    _cache = _cache.isEmpty ? _generateProducts() : _cache;
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final start = page * pageSize;
    if (start >= _cache.length) return [];
    final end = math.min(start + pageSize, _cache.length);
    return _cache.sublist(start, end);
  }

  static List<Product> allProducts() {
    _cache = _cache.isEmpty ? _generateProducts() : _cache;
    return List<Product>.from(_cache);
  }

  static Map<String, double> decodeRatings(String source) {
    final map = jsonDecode(source) as Map<String, dynamic>;
    return map.map((key, value) => MapEntry(key, (value as num).toDouble()));
  }

  static String encodeRatings(Map<String, double> ratings) => jsonEncode(ratings);

  static List<Product> _generateProducts() {
    final templates = <Product>[
      const Product(
        id: 'template_1',
        heroTag: 'hero_template_1',
        nameEn: 'Neon Courier Capsule',
        nameAr: 'كبسولة التوصيل النيونية',
        descriptionEn: 'Pop-engineered storage capsule with holographic tracking overlay.',
        descriptionAr: 'كبسولة تخزين هندسية مع طبقة تتبع هولوجرافية.',
        price: 126,
        featuresEn: ['Magnetic docking ring', 'Eco charge battery', 'Gesture unlock'],
        featuresAr: ['حلقة تثبيت مغناطيسية', 'بطارية شحن بيئي', 'فتح بالإيماءات'],
        imageUrls: [
          'https://picsum.photos/seed/hyper_capsule_1/720/720',
          'https://picsum.photos/seed/hyper_capsule_2/720/720',
          'https://picsum.photos/seed/hyper_capsule_3/720/720',
        ],
        initialRating: 4.4,
        accentColor: Color(0xFF82C93C),
      ),
      const Product(
        id: 'template_2',
        heroTag: 'hero_template_2',
        nameEn: 'Flux Pop Cart',
        nameAr: 'عربة فلوكس بوب',
        descriptionEn: 'Street-ready vending cart with augmented banner ribbons.',
        descriptionAr: 'عربة بيع جاهزة للشوارع مع شرائط شعار معززة.',
        price: 143,
        featuresEn: ['Foldable neon canopy', 'Tap-to-pay zone', 'Ambient sound diffuser'],
        featuresAr: ['مظلة نيون قابلة للطي', 'منطقة دفع باللمس', 'ناشر صوت محيطي'],
        imageUrls: [
          'https://picsum.photos/seed/hyper_cart_1/720/720',
          'https://picsum.photos/seed/hyper_cart_2/720/720',
          'https://picsum.photos/seed/hyper_cart_3/720/720',
        ],
        initialRating: 4.1,
        accentColor: Color(0xFFF97453),
      ),
      const Product(
        id: 'template_3',
        heroTag: 'hero_template_3',
        nameEn: 'Pulse Transit Crate',
        nameAr: 'صندوق العبور النابض',
        descriptionEn: 'Modular crate with embedded social commerce ticker.',
        descriptionAr: 'صندوق معياري مع شريط تواصل تجاري مدمج.',
        price: 118,
        featuresEn: ['Shared playlist dock', 'Smart humidity control', 'Quick swap skins'],
        featuresAr: ['منفذ قوائم تشغيل مشتركة', 'تحكم ذكي بالرطوبة', 'أغطية سريعة التغيير'],
        imageUrls: [
          'https://picsum.photos/seed/hyper_crate_1/720/720',
          'https://picsum.photos/seed/hyper_crate_2/720/720',
          'https://picsum.photos/seed/hyper_crate_3/720/720',
        ],
        initialRating: 4.6,
        accentColor: Color(0xFF000000),
      ),
    ];

    final items = <Product>[];
    for (var i = 0; i < 45; i++) {
      final template = templates[i % templates.length];
      final id = 'product_$i';
      items.add(
        Product(
          id: id,
          heroTag: 'hero_$id',
          nameEn: '${template.nameEn} ${i + 1}',
          nameAr: '${template.nameAr} ${i + 1}',
          descriptionEn: '${template.descriptionEn}\nEdition ${(i % 4) + 1}.',
          descriptionAr: '${template.descriptionAr}\nالإصدار ${(i % 4) + 1}.',
          price: template.price + (i % 5) * 4.2,
          featuresEn: template.featuresEn,
          featuresAr: template.featuresAr,
          imageUrls: template.imageUrls
              .map((url) => url.replaceAll('1', '${(i % 3) + 1}'))
              .toList(),
          initialRating: template.initialRating,
          accentColor: template.accentColor,
        ),
      );
    }
    return items;
  }
}

class FeatureIdeaRepository {
  static List<FeatureIdea> build(Locale _) {
    final ideasEn = <String>[
      'Advanced search with mood filters',
      'Dynamic price comparison radar',
      'Voice controlled shopping lists',
      'On-demand product customization studio',
      'Augmented reality placement preview',
      'Creator livestream shopping events',
      'Collaborative wishlists for squads',
      'Subscription boxes with adaptive themes',
      'Eco-impact scoring dashboard',
      'AI stylist recommendations',
      'Predictive restock alerts',
      'Neighborhood pickup lockers',
      'Drone delivery scheduling',
      'Gamified loyalty quests',
      'Integrated barter marketplace',
      'Smart contract powered rentals',
      'Crowd-voted product drops',
      'Multi-currency wallet support',
      'Secure escrow for high value trades',
      'In-app product insurance add-ons',
      'Live chat translation',
      'AR guided assembly tutorials',
      'Photo-to-product search',
      'Wearable device integrations',
      'Sustainability badges',
      'Carbon offset marketplace',
      'Hyperlocal artisan map',
      'Smart packaging return flow',
      'Donation matching program',
      'In-store pickup reservations',
      'Marketplace guild profiles with endorsements',
      'Dynamic vendor trust heatmaps',
      'In-app documentation builder',
      'Collaborative storefront editor',
      'Integrated sustainability pledges',
      'On-demand maker insurance options',
      'Predictive demand planning dashboard',
      'Shared reality livestream showrooms',
      'Immersive audio tours for products',
      'Autonomous courier coordination',
      'Smart contract escrow analytics',
      'User-generated style lookbooks',
      'Virtual queue management for drops',
      'Advanced barter negotiation room',
      'Voice-to-text negotiation transcripts',
      'Remote diagnostics for hardware',
      'Custom data export studio',
      'Integrated maker education hub',
      'AI-driven bundle composer',
      'Embedded carbon ledger explorer',
      'Offline pop-up sync support',
      'Hardware rental subscription management',
      'Geo-fenced campaign triggers',
      'Multi-vendor checkout flows',
      'Creator royalty tracking',
      'Augmented packaging instructions',
      'Donation impact visualizer',
      'Wholesale partner onboarding',
      'Community dispute mediation room',
      'Talent marketplace for pop-up staff',
    ];

    final ideasAr = <String>[
      'بحث متقدم مع مرشحات المزاج',
      'رادار مقارنة الأسعار الديناميكي',
      'قوائم تسوق بالتحكم الصوتي',
      'استوديو تخصيص المنتجات عند الطلب',
      'معاينة وضع المنتج بالواقع المعزز',
      'فعاليات تسوق بالبث المباشر للمبدعين',
      'قوائم رغبات تعاونية للفرق',
      'صناديق اشتراك بسمات متكيفة',
      'لوحة متابعة الأثر البيئي',
      'اقتراحات منسق ذكي',
      'تنبيهات توقع إعادة المخزون',
      'خزائن استلام في الحي',
      'جدولة التوصيل بالطائرات بدون طيار',
      'مهام ولاء gamified',
      'سوق مقايضة متكامل',
      'إيجارات مدعومة بالعقود الذكية',
      'إصدارات منتجات بالتصويت الجماعي',
      'دعم محفظة متعددة العملات',
      'ضمان آمن للصفقات عالية القيمة',
      'إضافات تأمين على المنتجات داخل التطبيق',
      'ترجمة فورية للدردشة',
      'دروس تركيب موجهة بالواقع المعزز',
      'بحث من صورة إلى منتج',
      'تكامل مع الأجهزة القابلة للارتداء',
      'شارات الاستدامة',
      'سوق تعويض الكربون',
      'خريطة الحرفيين المحليين',
      'تدفق لإرجاع التغليف الذكي',
      'برنامج مطابقة التبرعات',
      'حجوزات الاستلام من المتجر',
      'ملفات تعريف النقابات مع توصيات',
      'خرائط حرارية لثقة الموردين',
      'منشئ وثائق داخل التطبيق',
      'محرر واجهات المتجر التعاوني',
      'عهود استدامة مدمجة',
      'خيارات تأمين للمبدعين عند الطلب',
      'لوحة تخطيط الطلب التنبؤية',
      'صالات عرض بالبث المشترك المعزز',
      'جولات صوتية غامرة للمنتجات',
      'تنسيق المرسلين المستقلين',
      'تحليلات الضمان بالعقود الذكية',
      'ألبومات أنماط من إنشاء المستخدم',
      'إدارة طوابير افتراضية للإصدارات',
      'غرفة تفاوض متقدمة للمقايضة',
      'تفريغ صوتي فوري للمفاوضات',
      'تشخيصات عن بعد للأجهزة',
      'استوديو تصدير بيانات مخصص',
      'منصة تعليم للمبدعين مدمجة',
      'منشئ حزم بالذكاء الاصطناعي',
      'مستكشف دفتر الكربون المضمن',
      'دعم مزامنة المتاجر المؤقتة دون اتصال',
      'إدارة اشتراك إيجار المعدات',
      'مشغلات حملات محددة بالموقع',
      'تدفقات دفع متعددة الموردين',
      'تتبع عوائد المبدعين',
      'تعليمات تغليف معززة بالواقع',
      'مرئي أثر التبرعات',
      'إعداد شركاء الجملة',
      'غرفة وساطة نزاعات مجتمعية',
      'سوق مواهب لفرق المتاجر المؤقتة',
    ];

    return List.generate(60, (index) {
      return FeatureIdea(
        index: index + 1,
        textEn: ideasEn[index],
        textAr: ideasAr[index],
      );
    });
  }
}
