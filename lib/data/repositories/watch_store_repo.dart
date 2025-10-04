import 'dart:math';

import 'package:flutter/material.dart';

import '../models/app_feature.dart';
import '../models/watch_item.dart';
import 'settings_repo.dart';

class WatchStoreRepository {
  WatchStoreRepository(this.settingsRepository);

  final SettingsRepository settingsRepository;

  static final List<WatchItem> _catalog = [
    WatchItem(
      id: 1,
      name: 'Apple Watch Ultra 2',
      brand: 'Apple',
      price: 3850,
      oldPrice: 4099,
      rating: 4.9,
      imagePlaceholder: const Color(0xFF1B2242),
      colors: const [
        Color(0xFF1B2242),
        Color(0xFFFFA2C0),
        Color(0xFF00C9A6),
      ],
      description:
          'Advanced adventure-ready smartwatch with precision dual-frequency GPS and 36-hour battery life.',
      highlights: const [
        'Precision dual-frequency GPS',
        'Titanium frame • 100m water resistance',
        'Up to 72 hours in low power mode',
        'Ocean strap and alpine loop options',
      ],
      specs: const {
        'display': '49mm LTPO OLED',
        'battery': '36h typical use',
        'sensors': 'Blood oxygen • ECG • Depth gauge',
        'connectivity': 'Cellular • Wi‑Fi • UWB',
      },
      collection: 'performance',
      wristSizes: const ['130-200mm', '145-220mm'],
      badge: 'flagship_badge',
      badgeColor: const Color(0xFFFF6584),
    ),
    WatchItem(
      id: 2,
      name: 'Galaxy Watch 6 Classic',
      brand: 'Samsung',
      price: 2299,
      oldPrice: 2499,
      rating: 4.8,
      imagePlaceholder: const Color(0xFF111C2B),
      colors: const [
        Color(0xFF111C2B),
        Color(0xFFE6EEF8),
        Color(0xFF6B4EFF),
      ],
      description:
          'Rotating bezel design with personalized sleep coaching and Galaxy ecosystem integration.',
      highlights: const [
        'Exynos W930 dual-core',
        'Advanced sleep coaching with snore detection',
        'BioActive sensor for ECG & BP',
        'Google Assistant & Maps onboard',
      ],
      specs: const {
        'display': '47mm Super AMOLED',
        'battery': '40h typical use',
        'sensors': 'Heart rate • BP • Bioelectrical impedance',
        'connectivity': 'Bluetooth 5.3 • NFC',
      },
      collection: 'modern',
      wristSizes: const ['140-210mm'],
      badge: 'best_seller_badge',
      badgeColor: const Color(0xFF00D9A6),
    ),
    WatchItem(
      id: 3,
      name: 'Huawei Watch GT 4',
      brand: 'Huawei',
      price: 1399,
      rating: 4.7,
      imagePlaceholder: const Color(0xFF212D45),
      colors: const [
        Color(0xFF212D45),
        Color(0xFFF6B756),
        Color(0xFF5BC4FF),
      ],
      description:
          'Stylish geometric design with up to 14 days of battery and professional workout insights.',
      highlights: const [
        'Up to 14 days battery life',
        'Dual-band five-system GNSS',
        'TruSeen 5.5+ heart monitoring',
        'Wearable Calorie Management system',
      ],
      specs: const {
        'display': '46mm AMOLED',
        'battery': '14 days typical use',
        'sensors': 'Heart rate • SpO₂ • Temperature',
        'connectivity': 'Bluetooth 5.2',
      },
      collection: 'wellness',
      wristSizes: const ['135-215mm'],
      badge: 'long_lasting_badge',
      badgeColor: const Color(0xFF6B4EFF),
    ),
    WatchItem(
      id: 4,
      name: 'Garmin Fenix 7 Pro',
      brand: 'Garmin',
      price: 3299,
      rating: 4.85,
      imagePlaceholder: const Color(0xFF0D1A2E),
      colors: const [
        Color(0xFF0D1A2E),
        Color(0xFF2F4F4F),
        Color(0xFFFECE44),
      ],
      description:
          'Multi-sport GPS smartwatch with solar charging, endurance score, and rugged sapphire glass.',
      highlights: const [
        'Power Sapphire solar charging lens',
        'Endurance score and hill score metrics',
        'SatIQ technology for optimized GPS',
        'Pro sports apps and topographic maps',
      ],
      specs: const {
        'display': '47mm MIP transflective',
        'battery': '22 days smartwatch mode',
        'sensors': 'Pulse Ox • Altimeter • Compass',
        'connectivity': 'Multi-band GNSS • Wi‑Fi',
      },
      collection: 'outdoor',
      wristSizes: const ['125-208mm'],
      badge: 'adventure_badge',
      badgeColor: const Color(0xFFFFA736),
    ),
    WatchItem(
      id: 5,
      name: 'Fossil Gen 6 Wellness',
      brand: 'Fossil',
      price: 1175,
      rating: 4.5,
      imagePlaceholder: const Color(0xFF161E2A),
      colors: const [
        Color(0xFF161E2A),
        Color(0xFF8EA0B4),
        Color(0xFFE46497),
      ],
      description:
          'Fashion-first smartwatch with SpO₂ tracking, wellness dashboard, and fast charging support.',
      highlights: const [
        'Qualcomm 4100+ processor',
        'Google Wallet and YouTube Music',
        'Wellness app with continuous SpO₂',
        'Fast charge to 80% in 30 minutes',
      ],
      specs: const {
        'display': '44mm AMOLED',
        'battery': '24h + multi-day modes',
        'sensors': 'SpO₂ • Heart rate • Altimeter',
        'connectivity': 'Bluetooth • NFC',
      },
      collection: 'modern',
      wristSizes: const ['140-200mm'],
    ),
    WatchItem(
      id: 6,
      name: 'Withings ScanWatch 2',
      brand: 'Withings',
      price: 1599,
      rating: 4.6,
      imagePlaceholder: const Color(0xFF0F1F2D),
      colors: const [
        Color(0xFF0F1F2D),
        Color(0xFFF2EFE4),
        Color(0xFFE36363),
      ],
      description:
          'Hybrid smartwatch with medical-grade ECG, temperature tracking, and 30-day battery life.',
      highlights: const [
        'Medical-grade ECG & SpO₂',
        'Body temperature baseline tracking',
        'Respiratory scans & sleep tracking',
        '30-day battery with fast charge',
      ],
      specs: const {
        'display': 'Hybrid OLED',
        'battery': '30 days',
        'sensors': 'ECG • SpO₂ • Skin temperature',
        'connectivity': 'Bluetooth LE',
      },
      collection: 'timeless',
      wristSizes: const ['135-215mm'],
    ),
    WatchItem(
      id: 7,
      name: 'Amazfit Balance',
      brand: 'Amazfit',
      price: 899,
      rating: 4.4,
      imagePlaceholder: const Color(0xFF17212E),
      colors: const [
        Color(0xFF17212E),
        Color(0xFF3FA1FF),
        Color(0xFF52E5B6),
      ],
      description:
          'Ultra-light smartwatch with readiness scores, dual-band GPS, and advanced recovery insights.',
      highlights: const [
        'Readiness score & stress tracking',
        'Dual-band circularly polarized GPS',
        'Zepp Pay and Zepp Coach',
        'Ultra lightweight 35g build',
      ],
      specs: const {
        'display': '46mm AMOLED',
        'battery': '14 days typical use',
        'sensors': 'BioTracker 5.0 PPG • Temperature',
        'connectivity': 'Bluetooth 5.3 • Wi‑Fi',
      },
      collection: 'wellness',
      wristSizes: const ['140-210mm'],
    ),
    WatchItem(
      id: 8,
      name: 'Tag Heuer Connected Calibre',
      brand: 'Tag Heuer',
      price: 7999,
      rating: 4.95,
      imagePlaceholder: const Color(0xFF0E101D),
      colors: const [
        Color(0xFF0E101D),
        Color(0xFF2E4057),
        Color(0xFFD8A25E),
      ],
      description:
          'Luxury performance smartwatch with golf and motorsport insights, titanium build, and sapphire glass.',
      highlights: const [
        '45mm Grade 2 titanium case',
        'Exclusive golf and motorsport apps',
        'Full-day battery with 1h charge',
        'Customizable dials with heritage designs',
      ],
      specs: const {
        'display': '1.39" AMOLED',
        'battery': '24h typical use',
        'sensors': 'Heart rate • Accelerometer • Gyroscope',
        'connectivity': 'Bluetooth 5.0 • NFC',
      },
      collection: 'signature',
      wristSizes: const ['145-215mm'],
      badge: 'luxury_badge',
      badgeColor: const Color(0xFFFFD166),
    ),
    WatchItem(
      id: 9,
      name: 'Xiaomi Watch S3',
      brand: 'Xiaomi',
      price: 749,
      rating: 4.3,
      imagePlaceholder: const Color(0xFF15202C),
      colors: const [
        Color(0xFF15202C),
        Color(0xFF2B86FF),
        Color(0xFF62E3C4),
      ],
      description:
          'Modular bezel design with 15-day battery life, AI sleep monitoring, and 150+ sport modes.',
      highlights: const [
        'Interchangeable bezels and straps',
        'AI sleep monitoring and breathing coach',
        'Dual-frequency GPS with route import',
        'Bluetooth phone calls & wallet',
      ],
      specs: const {
        'display': '1.43" AMOLED',
        'battery': '15 days typical use',
        'sensors': 'Heart rate • SpO₂ • Barometer',
        'connectivity': 'Bluetooth 5.2 • NFC',
      },
      collection: 'urban',
      wristSizes: const ['140-210mm'],
    ),
    WatchItem(
      id: 10,
      name: 'Suunto Vertical Solar',
      brand: 'Suunto',
      price: 2899,
      rating: 4.65,
      imagePlaceholder: const Color(0xFF0B1A2B),
      colors: const [
        Color(0xFF0B1A2B),
        Color(0xFF3B5C68),
        Color(0xFF70E0A8),
      ],
      description:
          'Adventure companion with free offline maps, solar charging, and up to 60 days of battery life.',
      highlights: const [
        'Military-tested toughness',
        'Dual-band GNSS with SatIQ',
        'Offline maps and barometer',
        'Solar charging up to 60 days standby',
      ],
      specs: const {
        'display': '1.4" Matrix',
        'battery': '60 days standby',
        'sensors': 'Compass • Barometer • Pulse Ox',
        'connectivity': 'Bluetooth • Wi‑Fi',
      },
      collection: 'outdoor',
      wristSizes: const ['125-210mm'],
    ),
    WatchItem(
      id: 11,
      name: 'Fitbit Sense 2',
      brand: 'Fitbit',
      price: 999,
      rating: 4.2,
      imagePlaceholder: const Color(0xFF112530),
      colors: const [
        Color(0xFF112530),
        Color(0xFFEADBD0),
        Color(0xFFFD6585),
      ],
      description:
          'Stress management smartwatch with body response sensor, daily readiness score, and Fitbit Premium trials.',
      highlights: const [
        'EDA-based body response sensor',
        'Daily readiness and sleep profiles',
        'Google Maps & Wallet integration',
        '6-month Fitbit Premium included',
      ],
      specs: const {
        'display': '1.58" AMOLED',
        'battery': '6+ days',
        'sensors': 'EDA • Heart rate • SpO₂',
        'connectivity': 'Bluetooth 5.0 • NFC',
      },
      collection: 'wellness',
      wristSizes: const ['137-210mm'],
    ),
    WatchItem(
      id: 12,
      name: 'Montblanc Summit 3',
      brand: 'Montblanc',
      price: 4599,
      rating: 4.75,
      imagePlaceholder: const Color(0xFF161C2B),
      colors: const [
        Color(0xFF161C2B),
        Color(0xFF2E4057),
        Color(0xFFC1A57B),
      ],
      description:
          'Premium craftsmanship with genuine leather straps, Wear OS 3, and advanced fitness coaching.',
      highlights: const [
        'Titanium and stainless steel case',
        'Multi-day battery with rapid charging',
        'Running coach and stress manager',
        'Built-in altimeter and compass',
      ],
      specs: const {
        'display': '1.28" AMOLED',
        'battery': '72 hours combined',
        'sensors': 'Heart rate • SpO₂ • Altimeter',
        'connectivity': 'Bluetooth 5.0 • NFC',
      },
      collection: 'signature',
      wristSizes: const ['150-215mm'],
    ),
  ];

  Future<List<WatchItem>> fetchWatches({
    required int page,
    required int limit,
    String? query,
    String? collection,
  }) async {
    await Future.delayed(Duration(milliseconds: 240 + Random().nextInt(120)));
    Iterable<WatchItem> items = _catalog;
    if (collection != null && collection.isNotEmpty && collection != 'all') {
      items = items.where((watch) => watch.collection == collection);
    }
    if (query != null && query.isNotEmpty) {
      final lower = query.toLowerCase();
      items = items.where((watch) {
        final merged = [
          watch.name,
          watch.brand,
          watch.collection,
          ...watch.highlights,
          ...watch.specs.values,
        ].join(' ').toLowerCase();
        return merged.contains(lower);
      });
    }
    final sorted = items.toList()
      ..sort((a, b) {
        final aFavorite = settingsRepository.favoriteWatchIds.contains(a.id) ? 1 : 0;
        final bFavorite = settingsRepository.favoriteWatchIds.contains(b.id) ? 1 : 0;
        if (aFavorite != bFavorite) {
          return bFavorite.compareTo(aFavorite);
        }
        final ratingCompare = b.rating.compareTo(a.rating);
        if (ratingCompare != 0) {
          return ratingCompare;
        }
        return a.price.compareTo(b.price);
      });
    final start = page * limit;
    if (start >= sorted.length) {
      return [];
    }
    final end = min(start + limit, sorted.length);
    return sorted.sublist(start, end);
  }

  List<String> collections() {
    return ['all', 'performance', 'modern', 'wellness', 'outdoor', 'timeless', 'signature', 'urban'];
  }

  List<String> smartFilters() {
    return [
      'filter_new_in',
      'filter_ready_to_ship',
      'filter_top_rated',
      'filter_best_value',
      'filter_limited',
    ];
  }

  List<AppFeature> featuresCatalog() {
    return const [
      AppFeature(
        id: 'feature_quick_look',
        titleKey: 'feature_quick_look_title',
        descriptionKey: 'feature_quick_look_desc',
        icon: Icons.timelapse_rounded,
        category: 'experience_features',
      ),
      AppFeature(
        id: 'feature_dynamic_categories',
        titleKey: 'feature_dynamic_categories_title',
        descriptionKey: 'feature_dynamic_categories_desc',
        icon: Icons.category_rounded,
        category: 'experience_features',
      ),
      AppFeature(
        id: 'feature_dual_language',
        titleKey: 'feature_dual_language_title',
        descriptionKey: 'feature_dual_language_desc',
        icon: Icons.language_rounded,
        category: 'platform_features',
      ),
      AppFeature(
        id: 'feature_guest_mode',
        titleKey: 'feature_guest_mode_title',
        descriptionKey: 'feature_guest_mode_desc',
        icon: Icons.visibility_off_rounded,
        category: 'platform_features',
      ),
      AppFeature(
        id: 'feature_price_alerts',
        titleKey: 'feature_price_alerts_title',
        descriptionKey: 'feature_price_alerts_desc',
        icon: Icons.notifications_active_rounded,
        category: 'shopping_features',
      ),
      AppFeature(
        id: 'feature_smart_recommendations',
        titleKey: 'feature_smart_recommendations_title',
        descriptionKey: 'feature_smart_recommendations_desc',
        icon: Icons.psychology_alt_rounded,
        category: 'shopping_features',
      ),
      AppFeature(
        id: 'feature_personal_size',
        titleKey: 'feature_personal_size_title',
        descriptionKey: 'feature_personal_size_desc',
        icon: Icons.straighten_rounded,
        category: 'fit_features',
      ),
      AppFeature(
        id: 'feature_virtual_tryon',
        titleKey: 'feature_virtual_tryon_title',
        descriptionKey: 'feature_virtual_tryon_desc',
        icon: Icons.camera_front_rounded,
        category: 'fit_features',
      ),
      AppFeature(
        id: 'feature_trade_in',
        titleKey: 'feature_trade_in_title',
        descriptionKey: 'feature_trade_in_desc',
        icon: Icons.swap_horiz_rounded,
        category: 'shopping_features',
      ),
      AppFeature(
        id: 'feature_payment_plan',
        titleKey: 'feature_payment_plan_title',
        descriptionKey: 'feature_payment_plan_desc',
        icon: Icons.payments_rounded,
        category: 'shopping_features',
      ),
      AppFeature(
        id: 'feature_gift_wrap',
        titleKey: 'feature_gift_wrap_title',
        descriptionKey: 'feature_gift_wrap_desc',
        icon: Icons.card_giftcard_rounded,
        category: 'shopping_features',
      ),
      AppFeature(
        id: 'feature_battery_health',
        titleKey: 'feature_battery_health_title',
        descriptionKey: 'feature_battery_health_desc',
        icon: Icons.battery_charging_full_rounded,
        category: 'performance_features',
      ),
      AppFeature(
        id: 'feature_sleep_sync',
        titleKey: 'feature_sleep_sync_title',
        descriptionKey: 'feature_sleep_sync_desc',
        icon: Icons.nights_stay_rounded,
        category: 'wellness_features',
      ),
      AppFeature(
        id: 'feature_fitness_scores',
        titleKey: 'feature_fitness_scores_title',
        descriptionKey: 'feature_fitness_scores_desc',
        icon: Icons.fitness_center_rounded,
        category: 'wellness_features',
      ),
      AppFeature(
        id: 'feature_water_resistance',
        titleKey: 'feature_water_resistance_title',
        descriptionKey: 'feature_water_resistance_desc',
        icon: Icons.water_drop_rounded,
        category: 'performance_features',
      ),
      AppFeature(
        id: 'feature_material_tags',
        titleKey: 'feature_material_tags_title',
        descriptionKey: 'feature_material_tags_desc',
        icon: Icons.layers_rounded,
        category: 'experience_features',
      ),
      AppFeature(
        id: 'feature_movement_filter',
        titleKey: 'feature_movement_filter_title',
        descriptionKey: 'feature_movement_filter_desc',
        icon: Icons.filter_alt_rounded,
        category: 'shopping_features',
      ),
      AppFeature(
        id: 'feature_strap_builder',
        titleKey: 'feature_strap_builder_title',
        descriptionKey: 'feature_strap_builder_desc',
        icon: Icons.construction_rounded,
        category: 'fit_features',
      ),
      AppFeature(
        id: 'feature_collection_curation',
        titleKey: 'feature_collection_curation_title',
        descriptionKey: 'feature_collection_curation_desc',
        icon: Icons.star_rate_rounded,
        category: 'experience_features',
      ),
      AppFeature(
        id: 'feature_calendar_sync',
        titleKey: 'feature_calendar_sync_title',
        descriptionKey: 'feature_calendar_sync_desc',
        icon: Icons.calendar_today_rounded,
        category: 'platform_features',
      ),
      AppFeature(
        id: 'feature_voice_search',
        titleKey: 'feature_voice_search_title',
        descriptionKey: 'feature_voice_search_desc',
        icon: Icons.mic_rounded,
        category: 'platform_features',
      ),
      AppFeature(
        id: 'feature_launch_alerts',
        titleKey: 'feature_launch_alerts_title',
        descriptionKey: 'feature_launch_alerts_desc',
        icon: Icons.rocket_launch_rounded,
        category: 'shopping_features',
      ),
      AppFeature(
        id: 'feature_store_pickup',
        titleKey: 'feature_store_pickup_title',
        descriptionKey: 'feature_store_pickup_desc',
        icon: Icons.store_rounded,
        category: 'shopping_features',
      ),
      AppFeature(
        id: 'feature_warranty_tracker',
        titleKey: 'feature_warranty_tracker_title',
        descriptionKey: 'feature_warranty_tracker_desc',
        icon: Icons.verified_user_rounded,
        category: 'platform_features',
      ),
      AppFeature(
        id: 'feature_appointment_booking',
        titleKey: 'feature_appointment_booking_title',
        descriptionKey: 'feature_appointment_booking_desc',
        icon: Icons.event_available_rounded,
        category: 'experience_features',
      ),
      AppFeature(
        id: 'feature_recently_viewed',
        titleKey: 'feature_recently_viewed_title',
        descriptionKey: 'feature_recently_viewed_desc',
        icon: Icons.history_rounded,
        category: 'platform_features',
      ),
      AppFeature(
        id: 'feature_multi_currency',
        titleKey: 'feature_multi_currency_title',
        descriptionKey: 'feature_multi_currency_desc',
        icon: Icons.currency_exchange_rounded,
        category: 'shopping_features',
      ),
      AppFeature(
        id: 'feature_accessibility_zoom',
        titleKey: 'feature_accessibility_zoom_title',
        descriptionKey: 'feature_accessibility_zoom_desc',
        icon: Icons.accessibility_new_rounded,
        category: 'platform_features',
      ),
      AppFeature(
        id: 'feature_social_share',
        titleKey: 'feature_social_share_title',
        descriptionKey: 'feature_social_share_desc',
        icon: Icons.share_rounded,
        category: 'experience_features',
      ),
      AppFeature(
        id: 'feature_companion_app',
        titleKey: 'feature_companion_app_title',
        descriptionKey: 'feature_companion_app_desc',
        icon: Icons.phone_iphone_rounded,
        category: 'platform_features',
      ),
    ];
  }

  List<String> onboardingKeys() {
    return const [
      'onboarding_slide_curate',
      'onboarding_slide_track',
      'onboarding_slide_customize',
    ];
  }

  WatchItem? findById(int id) {
    try {
      return _catalog.firstWhere((element) => element.id == id);
    } catch (_) {
      return null;
    }
  }
}
