import '../models/locale_text.dart';
import '../models/marketplace_meta.dart';

class MarketplaceRepository {
  static final List<CategoryTag> categories = [
    CategoryTag(
      id: 'delivery',
      label: const LocaleText(en: 'Delivery Tech', ar: 'تقنية التوصيل'),
    ),
    CategoryTag(
      id: 'modular',
      label: const LocaleText(en: 'Modular Systems', ar: 'أنظمة معيارية'),
    ),
    CategoryTag(
      id: 'social',
      label: const LocaleText(en: 'Social Commerce', ar: 'تجارة اجتماعية'),
    ),
    CategoryTag(
      id: 'sustainable',
      label: const LocaleText(en: 'Sustainable Builds', ar: 'تصاميم مستدامة'),
    ),
    CategoryTag(
      id: 'experiential',
      label: const LocaleText(en: 'Experiential Retail', ar: 'تجارة تجريبية'),
    ),
  ];

  static final List<HighlightMetric> marketHighlights = [
    HighlightMetric(
      label: const LocaleText(en: 'Verified Makers', ar: 'صناع موثوقون'),
      value: '128',
    ),
    HighlightMetric(
      label: const LocaleText(en: 'Avg. Fulfillment Speed', ar: 'متوسط سرعة التنفيذ'),
      value: '36h',
    ),
    HighlightMetric(
      label: const LocaleText(en: 'Eco Impact Offset', ar: 'تعويض الأثر البيئي'),
      value: '92%',
    ),
  ];

  static final List<LocaleText> liveMoments = [
    const LocaleText(
      en: 'City sprint relay with neon courier crews — Today 18:00',
      ar: 'سباق التوصيل الحضري مع فرق النيون — اليوم 18:00',
    ),
    const LocaleText(
      en: 'Live customization lab: modular cart skins — Tomorrow 12:30',
      ar: 'مختبر التخصيص المباشر: أغطية العربة المعيارية — غداً 12:30',
    ),
    const LocaleText(
      en: 'Community sustainability clinic — Friday 16:00',
      ar: 'عيادة الاستدامة المجتمعية — الجمعة 16:00',
    ),
  ];

  static final List<MarketplaceCollection> collections = [
    MarketplaceCollection(
      id: 'night_shift',
      title: const LocaleText(en: 'Night Shift Couriers', ar: 'مرسلو الليل'),
      description: const LocaleText(
        en: 'Glow-up kits for late-night delivery squads.',
        ar: 'أطقم متألقة لفرق التوصيل الليلية.',
      ),
      productIds: const ['product_0', 'product_3', 'product_6', 'product_9'],
    ),
    MarketplaceCollection(
      id: 'pop_commons',
      title: const LocaleText(en: 'Pop Commons Hubs', ar: 'محاور بوب المشتركة'),
      description: const LocaleText(
        en: 'Modular kiosks ready for any plaza takeover.',
        ar: 'أكشاك معيارية جاهزة لأي ساحة.',
      ),
      productIds: const ['product_1', 'product_4', 'product_7', 'product_10'],
    ),
    MarketplaceCollection(
      id: 'eco_flow',
      title: const LocaleText(en: 'Eco Flow Stream', ar: 'تيار التدفق البيئي'),
      description: const LocaleText(
        en: 'Circular materials tuned for climate-positive drops.',
        ar: 'مواد دائرية مصممة لإصدارات إيجابية مناخياً.',
      ),
      productIds: const ['product_2', 'product_5', 'product_8', 'product_11'],
    ),
    MarketplaceCollection(
      id: 'street_stage',
      title: const LocaleText(en: 'Street Stage Showcases', ar: 'منصات الشارع الاستعراضية'),
      description: const LocaleText(
        en: 'Immersive retail rigs and projection-ready carts.',
        ar: 'منصات بيع غامرة وعربات جاهزة للإسقاط.',
      ),
      productIds: const ['product_12', 'product_13', 'product_14', 'product_15'],
    ),
  ];

  static final List<Vendor> vendors = [
    Vendor(
      id: 'vendor_flux',
      name: const LocaleText(en: 'Flux District Cooperative', ar: 'تعاونية حي فلوكس'),
      location: const LocaleText(en: 'Riyadh · Edge Corridor', ar: 'الرياض · الممر الحدودي'),
      story: const LocaleText(
        en: 'Open workshop turning courier ideas into modular realities.',
        ar: 'ورشة مفتوحة تحول أفكار المرسلين إلى واقع معياري.',
      ),
      focusAreas: const [
        LocaleText(en: 'Courier pods', ar: 'كبسولات التوصيل'),
        LocaleText(en: 'Sensor meshes', ar: 'شبكات الاستشعار'),
        LocaleText(en: 'Night safety rigs', ar: 'معدات سلامة ليلية'),
      ],
      rating: 4.8,
      since: 2019,
      avatarUrl: 'https://picsum.photos/seed/vendor_flux/160/160',
    ),
    Vendor(
      id: 'vendor_loop',
      name: const LocaleText(en: 'Loop Alley Syndicate', ar: 'اتحاد زقاق لوب'),
      location: const LocaleText(en: 'Dubai · Pop Arc', ar: 'دبي · القوس البوب'),
      story: const LocaleText(
        en: 'Designers remixing vending carts with live media fascias.',
        ar: 'مصممون يعيدون ابتكار عربات البيع بواجهات وسائط حية.',
      ),
      focusAreas: const [
        LocaleText(en: 'Immersive kiosks', ar: 'أكشاك غامرة'),
        LocaleText(en: 'Contactless trade', ar: 'تجارة بدون تلامس'),
        LocaleText(en: 'Event logistics', ar: 'لوجستيات الفعاليات'),
      ],
      rating: 4.6,
      since: 2017,
      avatarUrl: 'https://picsum.photos/seed/vendor_loop/160/160',
    ),
    Vendor(
      id: 'vendor_cargo',
      name: const LocaleText(en: 'Cargo Pulse Guild', ar: 'رابطة كارجو بالس'),
      location: const LocaleText(en: 'Jeddah · Waterfront Deck', ar: 'جدة · رصيف الواجهة البحرية'),
      story: const LocaleText(
        en: 'Climate-forward crate lab calibrating resilient packaging.',
        ar: 'مختبر صناديق متقدم مناخياً يضبط التغليف المرن.',
      ),
      focusAreas: const [
        LocaleText(en: 'Climate neutral crates', ar: 'صناديق محايدة مناخياً'),
        LocaleText(en: 'Collaborative storage', ar: 'تخزين تعاوني'),
        LocaleText(en: 'Rapid swap panels', ar: 'ألواح تبديل سريعة'),
      ],
      rating: 4.9,
      since: 2015,
      avatarUrl: 'https://picsum.photos/seed/vendor_cargo/160/160',
    ),
  ];

  static final List<TrustBadge> trustBadges = [
    TrustBadge(
      title: const LocaleText(en: 'Urban Lab Certified', ar: 'معتمد من مختبر المدينة'),
      description: const LocaleText(
        en: 'All makers audited quarterly across safety, labor, and sourcing.',
        ar: 'يتم تدقيق جميع الصناع ربع سنوياً في معايير السلامة والعمل والمصادر.',
      ),
    ),
    TrustBadge(
      title: const LocaleText(en: 'Climate Positive Pledge', ar: 'تعهد الإيجابية المناخية'),
      description: const LocaleText(
        en: 'Marketplace offsets 120% of emissions for every dispatch.',
        ar: 'يعوض السوق 120٪ من الانبعاثات لكل عملية إرسال.',
      ),
    ),
    TrustBadge(
      title: const LocaleText(en: 'Community Escrow Shield', ar: 'درع الضمان المجتمعي'),
      description: const LocaleText(
        en: 'Secure holding for high-value trades with instant dispute response.',
        ar: 'ضمان آمن للصفقات عالية القيمة مع استجابة فورية للنزاعات.',
      ),
    ),
  ];

  static final List<MarketplacePolicy> policies = [
    MarketplacePolicy(
      title: const LocaleText(en: '48h No-Questions Returns', ar: 'إرجاع خلال 48 ساعة دون أسئلة'),
      summary: const LocaleText(
        en: 'Full credit on unused builds. Instant courier dispatch for pickups.',
        ar: 'رصيد كامل للتصاميم غير المستخدمة. إرسال مرسل فوري للاستلام.',
      ),
    ),
    MarketplacePolicy(
      title: const LocaleText(en: 'Transparent Supply Ledger', ar: 'دفتر توريد شفاف'),
      summary: const LocaleText(
        en: 'Material origins visible on every product card and archived monthly.',
        ar: 'مصدر المواد ظاهر في كل بطاقة منتج ومؤرشف شهرياً.',
      ),
    ),
    MarketplacePolicy(
      title: const LocaleText(en: 'Creator Care Hotline', ar: 'خط رعاية المبدعين'),
      summary: const LocaleText(
        en: '24/7 multilingual channel for urgent support and wellbeing.',
        ar: 'قناة متعددة اللغات على مدار الساعة للدعم العاجل والرفاه.',
      ),
    ),
  ];

  static final List<MarketplaceReport> reports = [
    MarketplaceReport(
      period: const LocaleText(en: 'Q1 Transparency Digest', ar: 'ملخص الشفافية للربع الأول'),
      highlight: const LocaleText(
        en: '97% of builds now feature recycled aluminum framing.',
        ar: '97٪ من التصاميم تستخدم الآن إطارات من الألمنيوم المعاد تدويره.',
      ),
    ),
    MarketplaceReport(
      period: const LocaleText(en: 'Midyear Impact Pulse', ar: 'نبض الأثر في منتصف العام'),
      highlight: const LocaleText(
        en: 'Community events funded 14 new micro-maker labs.',
        ar: 'موّلت الفعاليات المجتمعية 14 مختبراً جديداً للمنتجين الصغار.',
      ),
    ),
    MarketplaceReport(
      period: const LocaleText(en: 'Annual Trust Ledger', ar: 'دفتر الثقة السنوي'),
      highlight: const LocaleText(
        en: 'Disputes resolved in under 4 hours on average.',
        ar: 'تم حل النزاعات خلال أقل من 4 ساعات في المتوسط.',
      ),
    ),
  ];

  static final List<MarketplaceStory> marketplaceStories = [
    MarketplaceStory(
      quote: const LocaleText(
        en: '“We scaled our street market residency in weeks thanks to verified builders.”',
        ar: '"وسعنا إقامتنا في سوق الشارع خلال أسابيع بفضل الصناع الموثوقين."',
      ),
      author: const LocaleText(en: 'Amina · Community Producer', ar: 'أمينة · منتجة مجتمعية'),
      role: const LocaleText(en: 'Runs the Riyadh Night Bazaar', ar: 'تشرف على بازار الرياض الليلي'),
    ),
    MarketplaceStory(
      quote: const LocaleText(
        en: '“Clients love the transparent sourcing cards—we close deals faster.”',
        ar: '"العملاء يعشقون بطاقات المصادر الشفافة — نغلق الصفقات أسرع."',
      ),
      author: const LocaleText(en: 'Khaled · Pop Architect', ar: 'خالد · مهندس بوب'),
      role: const LocaleText(en: 'Designs modular kiosks', ar: 'يصمم أكشاكاً معيارية'),
    ),
    MarketplaceStory(
      quote: const LocaleText(
        en: '“The escrow shield kept our cross-city swap protected and stress-free.”',
        ar: '"حافظ درع الضمان على عملية التبادل بين المدن محمية وخالية من التوتر."',
      ),
      author: const LocaleText(en: 'Lina · Experience Curator', ar: 'لينا · منسقة تجارب'),
      role: const LocaleText(en: 'Leads touring pop-ups', ar: 'تقود جولات المتاجر المؤقتة'),
    ),
  ];

  static final Map<String, ProductMeta> _metaCache = _buildMetas();
  static final Map<String, List<MarketplaceStory>> _productStories = _buildProductStories();
  static final Map<String, List<QaEntry>> _productQa = _buildProductQa();

  static ProductMeta metaFor(String productId) => _metaCache[productId] ?? _fallbackMeta(productId);

  static List<MarketplaceStory> testimonialsFor(String productId) =>
      _productStories[productId] ?? marketplaceStories.take(2).toList();

  static List<QaEntry> qaFor(String productId) => _productQa[productId] ?? _defaultQa();

  static ProductMeta _fallbackMeta(String productId) {
    return ProductMeta(
      productId: productId,
      vendorId: vendors.first.id,
      categoryIds: [categories.first.id],
      tags: const [LocaleText(en: 'Limited batch', ar: 'دفعة محدودة')],
      specLines: const [LocaleText(en: 'Awaiting spec upload', ar: 'بانتظار رفع المواصفات')],
      breakdown: const [
        PriceBreakdownItem(
          label: LocaleText(en: 'Core build', ar: 'التصميم الأساسي'),
          value: '\$120.00',
        ),
      ],
      shippingSteps: const [
        ShippingStep(
          label: LocaleText(en: 'Dispatch pending', ar: 'الإرسال قيد الانتظار'),
          detail: LocaleText(en: 'Shared once order confirmed', ar: 'يتم مشاركته بعد تأكيد الطلب'),
        ),
      ],
      qaEntries: _defaultQa(),
      highlightMetrics: const [
        HighlightMetric(label: LocaleText(en: 'Reliability', ar: 'الاعتمادية'), value: 'A'),
      ],
      sustainabilityScore: 0.6,
      sustainabilityNote: const LocaleText(
        en: 'Base compliance met. Full metrics published soon.',
        ar: 'تم استيفاء المتطلبات الأساسية. ستنشر القياسات كاملة قريباً.',
      ),
      materials: const [LocaleText(en: 'Composite shell', ar: 'غلاف مركب')],
      accessories: const [LocaleText(en: 'Starter toolkit', ar: 'عدة انطلاق')],
      guarantee: const LocaleText(
        en: '90-day service guarantee on moving parts.',
        ar: 'ضمان خدمة لمدة 90 يوماً على الأجزاء المتحركة.',
      ),
    );
  }

  static Map<String, ProductMeta> _buildMetas() {
    final metas = <String, ProductMeta>{};
    final templates = [
      _MetaTemplate(
        vendorId: 'vendor_flux',
        categoryIds: ['delivery', 'sustainable'],
        tags: const [
          LocaleText(en: 'Courier ready', ar: 'جاهز للمرسلين'),
          LocaleText(en: 'Sensor synced', ar: 'متزامن مع المستشعرات'),
          LocaleText(en: 'Night safe', ar: 'آمن ليلاً'),
        ],
        specLines: const [
          LocaleText(en: 'Payload up to 120kg', ar: 'حمولة تصل إلى 120 كجم'),
          LocaleText(en: 'Tri-lock magnetic seal', ar: 'ختم مغناطيسي ثلاثي'),
          LocaleText(en: 'Thermo-regulated core', ar: 'نواة منظمة حرارياً'),
        ],
        breakdown: const [
          PriceBreakdownItem(label: LocaleText(en: 'Shell fabrication', ar: 'تصنيع الهيكل'), value: '\$82.00'),
          PriceBreakdownItem(label: LocaleText(en: 'Sensor mesh', ar: 'شبكة المستشعرات'), value: '\$28.00'),
          PriceBreakdownItem(label: LocaleText(en: 'Creative surcharge', ar: 'رسوم إبداعية'), value: '\$16.00'),
        ],
        shippingSteps: const [
          ShippingStep(
            label: LocaleText(en: 'Build calibration', ar: 'معايرة التصميم'),
            detail: LocaleText(en: '12 hours in the Flux lab', ar: '12 ساعة في مختبر فلوكس'),
          ),
          ShippingStep(
            label: LocaleText(en: 'Courier pairing', ar: 'إقران المرسل'),
            detail: LocaleText(en: 'Match with rider profile', ar: 'مطابقة مع ملف الساعي'),
          ),
          ShippingStep(
            label: LocaleText(en: 'City dispatch', ar: 'إرسال للمدينة'),
            detail: LocaleText(en: 'Neon van deployment', ar: 'نشر عبر شاحنة نيون'),
          ),
        ],
        qaEntries: const [
          QaEntry(
            question: LocaleText(en: 'Does it support biometric locks?', ar: 'هل يدعم الأقفال البيومترية؟'),
            answer: LocaleText(en: 'Yes, integrate via the side AUX port.', ar: 'نعم، يمكن دمجه عبر منفذ AUX الجانبي.'),
          ),
          QaEntry(
            question: LocaleText(en: 'How weatherproof is the capsule?', ar: 'ما مدى مقاومة الكبسولة للطقس؟'),
            answer: LocaleText(en: 'Rated IP66 with reinforced seams.', ar: 'مصنفة IP66 مع لحامات معززة.'),
          ),
        ],
        highlightMetrics: const [
          HighlightMetric(label: LocaleText(en: 'Reliability', ar: 'الاعتمادية'), value: 'A+'),
          HighlightMetric(label: LocaleText(en: 'Energy Efficiency', ar: 'كفاءة الطاقة'), value: '92%'),
          HighlightMetric(label: LocaleText(en: 'Community Rating', ar: 'تقييم المجتمع'), value: '4.7'),
        ],
        sustainabilityScore: 0.88,
        sustainabilityNote: const LocaleText(
          en: 'Recycled shell panels and carbon neutral assembly line.',
          ar: 'ألواح هيكل معاد تدويرها وخط تجميع محايد كربونياً.',
        ),
        materials: const [
          LocaleText(en: 'Recycled poly shell', ar: 'غلاف بولي معاد تدويره'),
          LocaleText(en: 'Bamboo composite floor', ar: 'أرضية مركبة من الخيزران'),
          LocaleText(en: 'Biolum paint finish', ar: 'طلاء حيوي مضيء'),
        ],
        accessories: const [
          LocaleText(en: 'Courier hydration kit', ar: 'عدة ترطيب للمرسل'),
          LocaleText(en: 'Cold-chain insert', ar: 'ملحق سلسلة تبريد'),
          LocaleText(en: 'Signal beacon array', ar: 'صفيف منارات إشارة'),
        ],
        guarantee: const LocaleText(
          en: '2-year repair coverage with express swap service.',
          ar: 'تغطية إصلاح لمدة عامين مع خدمة تبديل سريعة.',
        ),
      ),
      _MetaTemplate(
        vendorId: 'vendor_loop',
        categoryIds: ['social', 'experiential'],
        tags: const [
          LocaleText(en: 'Livestream ready', ar: 'جاهز للبث المباشر'),
          LocaleText(en: 'Tap-to-pay core', ar: 'نواة دفع باللمس'),
          LocaleText(en: 'Modular canopy', ar: 'مظلة معيارية'),
        ],
        specLines: const [
          LocaleText(en: '360° LED ribbon fascia', ar: 'واجهة شريط LED بزاوية 360°'),
          LocaleText(en: 'Dual battery powertrain', ar: 'نظام طاقة ببطاريتين'),
          LocaleText(en: 'Fold-flat frame design', ar: 'تصميم إطار قابل للطي بالكامل'),
        ],
        breakdown: const [
          PriceBreakdownItem(label: LocaleText(en: 'Frame assembly', ar: 'تجميع الإطار'), value: '\$64.00'),
          PriceBreakdownItem(label: LocaleText(en: 'Interactive fascia', ar: 'واجهة تفاعلية'), value: '\$42.00'),
          PriceBreakdownItem(label: LocaleText(en: 'Support network', ar: 'شبكة الدعم'), value: '\$18.00'),
        ],
        shippingSteps: const [
          ShippingStep(
            label: LocaleText(en: 'Visual calibration', ar: 'معايرة مرئية'),
            detail: LocaleText(en: 'Upload brand kit to sync', ar: 'رفع هوية العلامة للمزامنة'),
          ),
          ShippingStep(
            label: LocaleText(en: 'On-street rehearsal', ar: 'بروفة ميدانية'),
            detail: LocaleText(en: '30-minute plaza test slot', ar: 'موعد اختبار في الساحة لمدة 30 دقيقة'),
          ),
          ShippingStep(
            label: LocaleText(en: 'Launch concierge', ar: 'إطلاق بإشراف'),
            detail: LocaleText(en: 'Crew assists first activation', ar: 'فريق يساعد في التفعيل الأول'),
          ),
        ],
        qaEntries: const [
          QaEntry(
            question: LocaleText(en: 'Can we run silent mode?', ar: 'هل يمكن تشغيل وضع صامت؟'),
            answer: LocaleText(en: 'Yes, swap to ambient diffuser preset.', ar: 'نعم، بدّل إلى إعداد الناشر المحيطي.'),
          ),
          QaEntry(
            question: LocaleText(en: 'What is the wind resistance?', ar: 'ما مقاومة الرياح؟'),
            answer: LocaleText(en: 'Stable up to 55 km/h gusts.', ar: 'مستقر حتى هبات 55 كم/س.'),
          ),
        ],
        highlightMetrics: const [
          HighlightMetric(label: LocaleText(en: 'Engagement Boost', ar: 'زيادة التفاعل'), value: '+38%'),
          HighlightMetric(label: LocaleText(en: 'Setup Time', ar: 'وقت التجهيز'), value: '14m'),
          HighlightMetric(label: LocaleText(en: 'Community Rating', ar: 'تقييم المجتمع'), value: '4.5'),
        ],
        sustainabilityScore: 0.82,
        sustainabilityNote: const LocaleText(
          en: 'Solar-ready canopy and reclaimed aluminum frame.',
          ar: 'مظلة جاهزة للطاقة الشمسية وإطار من الألمنيوم المعاد.',
        ),
        materials: const [
          LocaleText(en: 'Reclaimed aluminum', ar: 'ألمنيوم معاد تدويره'),
          LocaleText(en: 'Vegan leather wraps', ar: 'أغطية من الجلد النباتي'),
          LocaleText(en: 'Plant-based diffusion gels', ar: 'مواد نشر نباتية'),
        ],
        accessories: const [
          LocaleText(en: 'Contactless payment puck', ar: 'جهاز دفع دون لمس'),
          LocaleText(en: 'Livestream mic mount', ar: 'حامل ميكروفون للبث المباشر'),
          LocaleText(en: 'Shade extension kit', ar: 'مجموعة تمديد الظلال'),
        ],
        guarantee: const LocaleText(
          en: 'Season-long concierge upgrades and repairs.',
          ar: 'ترقيات وإصلاحات بإشراف طوال الموسم.',
        ),
      ),
      _MetaTemplate(
        vendorId: 'vendor_cargo',
        categoryIds: ['modular', 'sustainable'],
        tags: const [
          LocaleText(en: 'Stackable', ar: 'قابل للتكديس'),
          LocaleText(en: 'Humidity smart', ar: 'تحكم ذكي بالرطوبة'),
          LocaleText(en: 'Swap skins', ar: 'أغطية قابلة للتبديل'),
        ],
        specLines: const [
          LocaleText(en: 'Multi-zone storage grid', ar: 'شبكة تخزين متعددة المناطق'),
          LocaleText(en: 'Adaptive humidity valves', ar: 'صمامات رطوبة متكيفة'),
          LocaleText(en: 'IoT ticker integration', ar: 'تكامل شريط إنترنت الأشياء'),
        ],
        breakdown: const [
          PriceBreakdownItem(label: LocaleText(en: 'Core crate', ar: 'الصندوق الأساسي'), value: '\$58.00'),
          PriceBreakdownItem(label: LocaleText(en: 'IoT ticker', ar: 'شريط إنترنت الأشياء'), value: '\$36.00'),
          PriceBreakdownItem(label: LocaleText(en: 'Climate lining', ar: 'بطانة مناخية'), value: '\$24.00'),
        ],
        shippingSteps: const [
          ShippingStep(
            label: LocaleText(en: 'Module pairing', ar: 'إقران الوحدات'),
            detail: LocaleText(en: 'Select crate stack size', ar: 'اختيار حجم تكديس الصناديق'),
          ),
          ShippingStep(
            label: LocaleText(en: 'Data sync', ar: 'مزامنة البيانات'),
            detail: LocaleText(en: 'Connect analytics dashboard', ar: 'ربط لوحة التحليلات'),
          ),
          ShippingStep(
            label: LocaleText(en: 'Last-mile prep', ar: 'التحضير للمرحلة الأخيرة'),
            detail: LocaleText(en: 'Wrap with protective film', ar: 'تغليف بغشاء واقي'),
          ),
        ],
        qaEntries: const [
          QaEntry(
            question: LocaleText(en: 'Can panels be reskinned quickly?', ar: 'هل يمكن تبديل الألواح بسرعة؟'),
            answer: LocaleText(en: 'Yes, swap kits clip in under 3 minutes.', ar: 'نعم، يتم تثبيت مجموعات التبديل خلال أقل من 3 دقائق.'),
          ),
          QaEntry(
            question: LocaleText(en: 'What analytics are included?', ar: 'ما التحليلات المتوفرة؟'),
            answer: LocaleText(en: 'Heatmap, humidity, and dwell tracking.', ar: 'خرائط حرارية، رطوبة، وتتبع المكوث.'),
          ),
        ],
        highlightMetrics: const [
          HighlightMetric(label: LocaleText(en: 'Durability', ar: 'المتانة'), value: '1200 cycles'),
          HighlightMetric(label: LocaleText(en: 'Setup Time', ar: 'وقت التجهيز'), value: '9m'),
          HighlightMetric(label: LocaleText(en: 'Community Rating', ar: 'تقييم المجتمع'), value: '4.8'),
        ],
        sustainabilityScore: 0.9,
        sustainabilityNote: const LocaleText(
          en: 'Seagrass composites with lifetime take-back program.',
          ar: 'مركبات من الأعشاب البحرية مع برنامج استرجاع مدى الحياة.',
        ),
        materials: const [
          LocaleText(en: 'Seagrass composite panels', ar: 'ألواح مركبة من الأعشاب البحرية'),
          LocaleText(en: 'Recycled steel corners', ar: 'زوايا من الفولاذ المعاد'),
          LocaleText(en: 'Organic dyes', ar: 'أصباغ عضوية'),
        ],
        accessories: const [
          LocaleText(en: 'Telemetry hub', ar: 'وحدة قياس عن بُعد'),
          LocaleText(en: 'Collaborative ledger kit', ar: 'مجموعة دفتر تعاوني'),
          LocaleText(en: 'Rapid swap panel pack', ar: 'حزمة ألواح تبديل سريعة'),
        ],
        guarantee: const LocaleText(
          en: '5-year structural warranty with annual tune-ups.',
          ar: 'ضمان هيكلي لمدة 5 سنوات مع ضبط سنوي.',
        ),
      ),
    ];

    for (var i = 0; i < 45; i++) {
      final template = templates[i % templates.length];
      final productId = 'product_' + i.toString();
      metas[productId] = ProductMeta(
        productId: productId,
        vendorId: template.vendorId,
        categoryIds: template.categoryIds,
        tags: template.tags,
        specLines: template.specLines,
        breakdown: template.breakdown,
        shippingSteps: template.shippingSteps,
        qaEntries: template.qaEntries,
        highlightMetrics: template.highlightMetrics,
        sustainabilityScore: (template.sustainabilityScore - (i % 3) * 0.03).clamp(0.5, 1.0),
        sustainabilityNote: template.sustainabilityNote,
        materials: template.materials,
        accessories: template.accessories,
        guarantee: template.guarantee,
      );
    }
    return metas;
  }

  static Map<String, List<MarketplaceStory>> _buildProductStories() {
    final map = <String, List<MarketplaceStory>>{};
    for (var i = 0; i < 45; i++) {
      final base = marketplaceStories[i % marketplaceStories.length];
      final secondary = marketplaceStories[(i + 1) % marketplaceStories.length];
      map['product_' + i.toString()] = [base, secondary];
    }
    return map;
  }

  static Map<String, List<QaEntry>> _buildProductQa() {
    final map = <String, List<QaEntry>>{};
    for (var i = 0; i < 45; i++) {
      final template = _metaCache['product_' + i.toString()];
      map['product_' + i.toString()] = template?.qaEntries ?? _defaultQa();
    }
    return map;
  }

  static List<QaEntry> _defaultQa() => const [
        QaEntry(
          question: LocaleText(en: 'How long is the build cycle?', ar: 'ما مدة دورة البناء؟'),
          answer: LocaleText(en: 'Average lead time is 5 days.', ar: 'متوسط الزمن اللازم 5 أيام.'),
        ),
        QaEntry(
          question: LocaleText(en: 'Is training included?', ar: 'هل التدريب مشمول؟'),
          answer: LocaleText(en: 'Yes, remote onboarding session for crews.', ar: 'نعم، جلسة تعريف عن بعد للفرق.'),
        ),
      ];
}

class _MetaTemplate {
  const _MetaTemplate({
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
