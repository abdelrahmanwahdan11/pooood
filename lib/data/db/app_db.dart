import 'dart:async';
import 'package:sqflite/sqflite.dart';

import '../models/auction.dart';
import '../models/discount_deal.dart';
import '../models/notification_item.dart';
import '../models/price_watch.dart';
import '../models/product.dart';
import '../models/user.dart';

class AppDatabase {
  AppDatabase._();

  static final AppDatabase instance = AppDatabase._();
  Database? _database;

  Database get db => _database!;

  Future<Database> init() async {
    if (_database != null) return _database!;
    final dbPath = await getDatabasesPath();
    final path = '$dbPath/liquid_bid.db';
    _database = await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
    await _seed();
    return _database!;
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY,
        name TEXT,
        avatarUrl TEXT,
        phone TEXT,
        email TEXT,
        defaultLocation TEXT,
        paymentMethod TEXT
      );
    ''');

    await db.execute('''
      CREATE TABLE products(
        id INTEGER PRIMARY KEY,
        title TEXT,
        category TEXT,
        condition TEXT,
        images TEXT,
        location TEXT,
        description TEXT
      );
    ''');

    await db.execute('''
      CREATE TABLE auctions(
        id INTEGER PRIMARY KEY,
        productId INTEGER,
        sellerName TEXT,
        sellerArea TEXT,
        distanceKm REAL,
        currentPrice REAL,
        minIncrement REAL,
        watchers INTEGER,
        views INTEGER,
        startTime INTEGER,
        endTime INTEGER,
        ownerId INTEGER,
        isFavorite INTEGER
      );
    ''');

    await db.execute('''
      CREATE TABLE discounts(
        id INTEGER PRIMARY KEY,
        storeName TEXT,
        product TEXT,
        category TEXT,
        discountPercent REAL,
        originalPrice REAL,
        distanceKm REAL,
        location TEXT,
        validFrom INTEGER,
        validUntil INTEGER,
        terms TEXT,
        images TEXT,
        ownerId INTEGER
      );
    ''');

    await db.execute('''
      CREATE TABLE price_watches(
        id INTEGER PRIMARY KEY,
        title TEXT,
        category TEXT,
        desiredPrice REAL,
        acceptableRange REAL,
        notes TEXT,
        preferredAreas TEXT,
        expiryDate INTEGER,
        contactPreference TEXT,
        receiveAlerts INTEGER,
        matches INTEGER
      );
    ''');

    await db.execute('''
      CREATE TABLE pricing_requests(
        id INTEGER PRIMARY KEY,
        category TEXT,
        brand TEXT,
        model TEXT,
        year INTEGER,
        condition TEXT,
        market TEXT,
        quantity INTEGER,
        location TEXT,
        photoUrls TEXT,
        description TEXT,
        timeframe TEXT
      );
    ''');

    await db.execute('''
      CREATE TABLE notifications(
        id INTEGER PRIMARY KEY,
        title TEXT,
        body TEXT,
        createdAt INTEGER,
        read INTEGER,
        type TEXT
      );
    ''');
  }

  Future<void> _seed() async {
    final userCount = Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM users'),
        ) ??
        0;
    if (userCount > 0) return;

    final user = User(
      id: 1,
      name: 'Lina Al-Majed',
      avatarUrl:
          'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=200&q=60',
      phone: '+966500000000',
      email: 'lina@liquidbid.app',
      defaultLocation: 'Riyadh Downtown',
      paymentMethod: '•••• 4421',
    );
    await db.insert('users', user.toMap());

    final products = <Product>[
      Product(
        id: 1,
        title: 'Rolex Submariner 2021',
        category: 'Luxury Watches',
        condition: 'Like New',
        images: const [
          'https://images.unsplash.com/photo-1524592094714-0f0654e20314?auto=format&fit=crop&w=1200&q=80',
          'https://images.unsplash.com/photo-1518544801976-3e159e41f9a5?auto=format&fit=crop&w=1200&q=80',
        ],
        location: 'Riyadh',
        description: 'Certified Rolex Submariner with box and papers.',
      ),
      Product(
        id: 2,
        title: 'Tesla Model 3 Performance',
        category: 'Electric Cars',
        condition: 'Good',
        images: const [
          'https://images.unsplash.com/photo-1503736334956-4c8f8e92946d?auto=format&fit=crop&w=1200&q=80',
          'https://images.unsplash.com/photo-1517949908114-720226b55b07?auto=format&fit=crop&w=1200&q=80',
        ],
        location: 'Jeddah',
        description: 'Performance AWD with autopilot and low mileage.',
      ),
      Product(
        id: 3,
        title: 'Apple MacBook Pro 16" M3',
        category: 'Electronics',
        condition: 'New',
        images: const [
          'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?auto=format&fit=crop&w=1200&q=80',
        ],
        location: 'Khobar',
        description: 'Sealed MacBook Pro with AppleCare+ until 2026.',
      ),
      Product(
        id: 4,
        title: 'Vintage Persian Rug',
        category: 'Home Decor',
        condition: 'Good',
        images: const [
          'https://images.unsplash.com/photo-1519710164239-da123dc03ef4?auto=format&fit=crop&w=1200&q=80',
        ],
        location: 'Riyadh',
        description: 'Hand-knotted Tabriz rug, 1960s, excellent colors.',
      ),
      Product(
        id: 5,
        title: 'Canon EOS R5 Mirrorless',
        category: 'Photography',
        condition: 'Like New',
        images: const [
          'https://images.unsplash.com/photo-1519183071298-a2962be90b8e?auto=format&fit=crop&w=1200&q=80',
        ],
        location: 'Dammam',
        description: 'Professional mirrorless camera with RF 24-70 lens.',
      ),
      Product(
        id: 6,
        title: 'Custom Gaming PC RTX 4090',
        category: 'Gaming',
        condition: 'New',
        images: const [
          'https://images.unsplash.com/photo-1587202372775-98927aab6172?auto=format&fit=crop&w=1200&q=80',
        ],
        location: 'Riyadh',
        description: 'Liquid-cooled build with Ryzen 9 and 64GB RAM.',
      ),
      Product(
        id: 7,
        title: 'Mercedes G-Class 2020',
        category: 'Luxury Cars',
        condition: 'Excellent',
        images: const [
          'https://images.unsplash.com/photo-1517677208171-0bc6725a3e60?auto=format&fit=crop&w=1200&q=80',
        ],
        location: 'Jeddah',
        description: 'AMG package, full service history.',
      ),
      Product(
        id: 8,
        title: 'Diamond Tennis Bracelet',
        category: 'Jewelry',
        condition: 'New',
        images: const [
          'https://images.unsplash.com/photo-1503387762-592deb58ef4e?auto=format&fit=crop&w=1200&q=80',
        ],
        location: 'Riyadh',
        description: '18K white gold with VS clarity diamonds.',
      ),
    ];

    for (final product in products) {
      await db.insert('products', product.toMap());
    }

    final now = DateTime.now();
    final auctions = <Auction>[
      Auction(
        id: 1,
        productId: 1,
        sellerName: 'Noor Luxury',
        sellerArea: 'Kingdom Centre',
        distanceKm: 3.4,
        currentPrice: 42000,
        minIncrement: 500,
        watchers: 32,
        views: 140,
        startTime: now.subtract(const Duration(days: 1)),
        endTime: now.add(const Duration(hours: 5)),
        ownerId: 1,
        isFavorite: true,
      ),
      Auction(
        id: 2,
        productId: 2,
        sellerName: 'EV Garage',
        sellerArea: 'Jeddah Corniche',
        distanceKm: 11.2,
        currentPrice: 210000,
        minIncrement: 2500,
        watchers: 54,
        views: 320,
        startTime: now.subtract(const Duration(days: 2)),
        endTime: now.add(const Duration(hours: 12)),
        ownerId: 1,
        isFavorite: false,
      ),
      Auction(
        id: 3,
        productId: 3,
        sellerName: 'Tech Avenue',
        sellerArea: 'Khobar Mall',
        distanceKm: 7.6,
        currentPrice: 9800,
        minIncrement: 200,
        watchers: 89,
        views: 500,
        startTime: now.subtract(const Duration(days: 1)),
        endTime: now.add(const Duration(hours: 2)),
        ownerId: 1,
        isFavorite: true,
      ),
      Auction(
        id: 4,
        productId: 4,
        sellerName: 'Gallery Tabriz',
        sellerArea: 'Diplomatic Quarter',
        distanceKm: 5.1,
        currentPrice: 27000,
        minIncrement: 800,
        watchers: 21,
        views: 112,
        startTime: now.subtract(const Duration(days: 3)),
        endTime: now.add(const Duration(days: 1)),
        ownerId: 1,
        isFavorite: false,
      ),
      Auction(
        id: 5,
        productId: 5,
        sellerName: 'Lens Lab',
        sellerArea: 'Dammam Seafront',
        distanceKm: 9.4,
        currentPrice: 14500,
        minIncrement: 250,
        watchers: 65,
        views: 230,
        startTime: now.subtract(const Duration(hours: 12)),
        endTime: now.add(const Duration(hours: 30)),
        ownerId: 1,
        isFavorite: false,
      ),
      Auction(
        id: 6,
        productId: 6,
        sellerName: 'Quantum Builds',
        sellerArea: 'Riyadh Digital City',
        distanceKm: 4.8,
        currentPrice: 17500,
        minIncrement: 300,
        watchers: 112,
        views: 640,
        startTime: now.subtract(const Duration(hours: 18)),
        endTime: now.add(const Duration(hours: 6)),
        ownerId: 1,
        isFavorite: true,
      ),
      Auction(
        id: 7,
        productId: 7,
        sellerName: 'Elite Motors',
        sellerArea: 'Jeddah Auto Mile',
        distanceKm: 15.8,
        currentPrice: 590000,
        minIncrement: 10000,
        watchers: 18,
        views: 210,
        startTime: now.subtract(const Duration(days: 1)),
        endTime: now.add(const Duration(days: 2)),
        ownerId: 1,
        isFavorite: false,
      ),
      Auction(
        id: 8,
        productId: 8,
        sellerName: 'Opulent Jewels',
        sellerArea: 'Riyadh Gallery',
        distanceKm: 2.3,
        currentPrice: 38000,
        minIncrement: 600,
        watchers: 40,
        views: 170,
        startTime: now.subtract(const Duration(hours: 10)),
        endTime: now.add(const Duration(hours: 20)),
        ownerId: 1,
        isFavorite: true,
      ),
    ];

    for (final auction in auctions) {
      await db.insert('auctions', auction.toMap());
    }

    final discounts = <DiscountDeal>[
      DiscountDeal(
        id: 1,
        storeName: 'Glow Beauty',
        product: 'Luxury skincare bundle',
        category: 'Beauty',
        discountPercent: 35,
        originalPrice: 950,
        distanceKm: 3.2,
        location: 'Riyadh Park',
        validFrom: now.subtract(const Duration(days: 1)),
        validUntil: now.add(const Duration(days: 5)),
        terms: 'Limited to 2 per customer. Redeem before 10pm.',
        images: const [
          'https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?auto=format&fit=crop&w=1200&q=80',
        ],
        ownerId: 1,
      ),
      DiscountDeal(
        id: 2,
        storeName: 'Pure Fitness',
        product: 'Annual membership',
        category: 'Fitness',
        discountPercent: 45,
        originalPrice: 2400,
        distanceKm: 4.5,
        location: 'Al Olaya',
        validFrom: now.subtract(const Duration(days: 2)),
        validUntil: now.add(const Duration(days: 3)),
        terms: 'Includes personal trainer sessions.',
        images: const [
          'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?auto=format&fit=crop&w=1200&q=80',
        ],
        ownerId: 1,
      ),
      DiscountDeal(
        id: 3,
        storeName: 'Gourmet Bites',
        product: 'Chef tasting menu',
        category: 'Dining',
        discountPercent: 25,
        originalPrice: 650,
        distanceKm: 1.7,
        location: 'Boulevard Riyadh',
        validFrom: now.subtract(const Duration(days: 3)),
        validUntil: now.add(const Duration(days: 1)),
        terms: 'Reservation required. Weekdays only.',
        images: const [
          'https://images.unsplash.com/photo-1478145046317-39f10e56b5e9?auto=format&fit=crop&w=1200&q=80',
        ],
        ownerId: 1,
      ),
      DiscountDeal(
        id: 4,
        storeName: 'RideNow Bikes',
        product: 'E-bike commuter',
        category: 'Mobility',
        discountPercent: 30,
        originalPrice: 5400,
        distanceKm: 6.8,
        location: 'King Abdullah Road',
        validFrom: now.subtract(const Duration(days: 1)),
        validUntil: now.add(const Duration(days: 7)),
        terms: 'Includes helmet and yearly service.',
        images: const [
          'https://images.unsplash.com/photo-1518655048521-f130df041f66?auto=format&fit=crop&w=1200&q=80',
        ],
        ownerId: 1,
      ),
    ];

    for (final discount in discounts) {
      await db.insert('discounts', discount.toMap());
    }

    final watches = <PriceWatch>[
      PriceWatch(
        id: 1,
        title: 'Certified iPhone 15 Pro',
        category: 'Electronics',
        desiredPrice: 4200,
        acceptableRange: 300,
        notes: 'Prefer blue titanium, warranty a plus.',
        preferredAreas: 'Riyadh, Khobar',
        expiryDate: now.add(const Duration(days: 14)),
        contactPreference: 'Phone',
        receiveAlerts: true,
        matches: 3,
      ),
      PriceWatch(
        id: 2,
        title: 'Range Rover Vogue 2019',
        category: 'SUV',
        desiredPrice: 320000,
        acceptableRange: 15000,
        notes: 'Must have service history. White or black.',
        preferredAreas: 'Jeddah',
        expiryDate: now.add(const Duration(days: 28)),
        contactPreference: 'Email',
        receiveAlerts: true,
        matches: 1,
      ),
    ];

    for (final watch in watches) {
      await db.insert('price_watches', watch.toMap());
    }

    final notifications = <NotificationItem>[
      NotificationItem(
        id: 1,
        title: 'Auction ending soon',
        body: 'Rolex Submariner closes in under 5 hours.',
        createdAt: now.subtract(const Duration(hours: 1)),
        read: false,
        type: 'auction',
      ),
      NotificationItem(
        id: 2,
        title: 'Discount match',
        body: 'Pure Fitness membership meets your criteria.',
        createdAt: now.subtract(const Duration(hours: 3)),
        read: true,
        type: 'discount',
      ),
    ];

    for (final notification in notifications) {
      await db.insert('notifications', notification.toMap());
    }
  }
}
