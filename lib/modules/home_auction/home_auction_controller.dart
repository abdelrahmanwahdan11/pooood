import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/models/auction.dart';
import '../../data/repositories/auction_repository.dart';
import '../../services/widget_service.dart';

class HomeAuctionController extends GetxController {
  HomeAuctionController();

  final _auctions = <Auction>[].obs;
  final PageController pageController = PageController(viewportFraction: 0.88);

  List<Auction> get auctions => _auctions;

  AuctionRepository get _repository => Get.find<AuctionRepository>();
  final WidgetService _widgetService = WidgetService();

  @override
  void onInit() {
    super.onInit();
    _auctions.assignAll(_repository.getAuctions());
  }

  void selectAuction(int index) {
    if (index < 0 || index >= _auctions.length) return;
    final auction = _auctions[index];
    _widgetService.updateSelectedAuction(id: auction.id, title: auction.product.title);
  }
}
