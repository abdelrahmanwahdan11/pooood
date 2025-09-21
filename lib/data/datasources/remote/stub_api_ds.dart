import 'dart:convert';

import 'package:flutter/services.dart' show AssetBundle, rootBundle;

import '../../models/auction.dart';
import '../../models/bid.dart';
import '../../models/product.dart';

class StubApiDataSource {
  StubApiDataSource({this.bundle = rootBundle});

  final AssetBundle bundle;

  List<Auction>? _auctions;
  List<Product>? _products;
  List<Bid>? _bids;
  List<Map<String, dynamic>>? _pricingSamples;

  Future<List<Auction>> fetchAuctions() async {
    if (_auctions != null) return _auctions!;
    final raw = await bundle.loadString('assets/mock/auctions.json');
    final List<dynamic> list = jsonDecode(raw) as List<dynamic>;
    final products = await fetchProducts();
    _auctions = list
        .map((e) => Auction.fromJson(e as Map<String, dynamic>))
        .map(
          (auction) => auction.copyWith(
            product: products.firstWhere(
              (product) => product.id == auction.productId,
              orElse: () => Product(
                id: auction.productId,
                title: auction.title,
                brand: 'Unknown',
                category: 'General',
                images: auction.images,
                basePrice: auction.currentBid,
              ),
            ),
          ),
        )
        .toList();
    return _auctions!;
  }

  Future<Auction?> fetchAuctionById(String id) async {
    final auctions = await fetchAuctions();
    try {
      return auctions.firstWhere((element) => element.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<List<Bid>> fetchBids(String auctionId) async {
    if (_bids == null) {
      final raw = await bundle.loadString('assets/mock/bids.json');
      final List<dynamic> list = jsonDecode(raw) as List<dynamic>;
      _bids = list.map((e) => Bid.fromJson(e as Map<String, dynamic>)).toList();
    }
    return _bids!
        .where((bid) => bid.auctionId == auctionId)
        .toList()
      ..sort((a, b) => b.placedAt.compareTo(a.placedAt));
  }

  Future<List<Product>> fetchProducts() async {
    if (_products != null) return _products!;
    final raw = await bundle.loadString('assets/mock/products.json');
    final List<dynamic> list = jsonDecode(raw) as List<dynamic>;
    _products = list.map((e) => Product.fromJson(e as Map<String, dynamic>)).toList();
    return _products!;
  }

  Future<List<Map<String, dynamic>>> fetchPricingSamples() async {
    if (_pricingSamples != null) return _pricingSamples!;
    final raw = await bundle.loadString('assets/mock/pricing_samples.json');
    final List<dynamic> list = jsonDecode(raw) as List<dynamic>;
    _pricingSamples =
        list.map((e) => Map<String, dynamic>.from(e as Map<String, dynamic>)).toList();
    return _pricingSamples!;
  }
}
