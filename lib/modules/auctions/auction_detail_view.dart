import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/utils/currency_utils.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/countdown_timer.dart';
import '../../core/widgets/gradient_scaffold.dart';
import '../../core/widgets/shimmer_loader.dart';
import '../../data/models/auction.dart';
import 'auctions_controller.dart';

class AuctionDetailView extends StatefulWidget {
  const AuctionDetailView({super.key, required this.auctionId});

  final String auctionId;

  @override
  State<AuctionDetailView> createState() => _AuctionDetailViewState();
}

class _AuctionDetailViewState extends State<AuctionDetailView> {
  late final AuctionsController controller;
  Auction? auction;
  bool loading = true;
  final TextEditingController _bidController = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller = Get.find<AuctionsController>();
    _load();
  }

  Future<void> _load() async {
    final data = await controller.getAuctionById(widget.auctionId);
    if (!mounted) return;
    setState(() {
      auction = data;
      loading = false;
    });
    if (data != null) {
      final suggested = (data.currentBid + data.minIncrement);
      _bidController.text = suggested.toStringAsFixed(0);
      await controller.loadBids(widget.auctionId);
    }
  }

  Future<void> _placeBid() async {
    final amount = double.tryParse(_bidController.text);
    if (amount == null || auction == null) {
      Get.snackbar('error'.tr, 'bid_placeholder'.tr);
      return;
    }
    if (amount < auction!.currentBid + auction!.minIncrement) {
      Get.snackbar(
        'warning'.tr,
        '${'min_increment'.tr}: ${CurrencyUtils.format(auction!.minIncrement)}',
      );
      return;
    }
    await controller.placeBid(auctionId: widget.auctionId, amount: amount);
    await _load();
    Get.snackbar('success'.tr, 'bid_submitted'.tr);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GradientScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(auction?.title ?? 'auctions'.tr),
      ),
      body: loading
          ? const Center(child: ShimmerLoader(height: 200))
          : auction == null
              ? Center(
                  child: Text('empty_state'.tr),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _ImageCarousel(images: auction!.images),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('current_bid'.tr, style: theme.textTheme.titleSmall),
                              Text(
                                CurrencyUtils.format(auction!.currentBid),
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('ends_in'.tr, style: theme.textTheme.titleSmall),
                              CountdownTimer(
                                endAt: auction!.endAt,
                                ticker: controller.ticker,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontFeatures: const [FontFeature.tabularFigures()],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        auction!.description,
                        style: theme.textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 20),
                      _BidEditor(
                        controller: _bidController,
                        onIncrease: () {
                          final value = double.tryParse(_bidController.text) ?? 0;
                          _bidController.text =
                              (value + auction!.minIncrement).toStringAsFixed(0);
                        },
                        onDecrease: () {
                          final value = double.tryParse(_bidController.text) ?? 0;
                          final min = auction!.currentBid + auction!.minIncrement;
                          final next = value - auction!.minIncrement;
                          _bidController.text =
                              (next < min ? min : next).toStringAsFixed(0);
                        },
                        hintText: 'bid_placeholder'.tr,
                      ),
                      const SizedBox(height: 12),
                      AppButton(
                        label: 'place_bid'.tr,
                        icon: Icons.send,
                        onPressed: _placeBid,
                        isExpanded: true,
                      ),
                      const SizedBox(height: 24),
                      Text('similar_items'.tr, style: theme.textTheme.titleMedium),
                      const SizedBox(height: 12),
                      Obx(() {
                        final bids = controller.bidsFor(widget.auctionId);
                        if (bids.isEmpty) {
                          return Text('empty_state'.tr);
                        }
                        return Column(
                          children: bids
                              .map(
                                (bid) => ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(CurrencyUtils.format(bid.amount)),
                                  subtitle: Text(bid.userId),
                                  trailing: Text(
                                    TimeOfDay.fromDateTime(bid.placedAt)
                                        .format(context),
                                  ),
                                ),
                              )
                              .toList(),
                        );
                      }),
                    ],
                  ),
                ),
    );
  }

  @override
  void dispose() {
    _bidController.dispose();
    super.dispose();
  }
}

class _ImageCarousel extends StatelessWidget {
  const _ImageCarousel({required this.images});

  final List<String> images;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: PageView.builder(
        itemCount: images.length,
        controller: PageController(viewportFraction: 0.9),
        itemBuilder: (context, index) {
          final url = images[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: CachedNetworkImage(
                imageUrl: url,
                fit: BoxFit.cover,
                placeholder: (context, url) => const ShimmerLoader(height: 220),
                errorWidget: (context, url, error) => Container(
                  color: Colors.black12,
                  alignment: Alignment.center,
                  child: const Icon(Icons.broken_image),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _BidEditor extends StatelessWidget {
  const _BidEditor({
    required this.controller,
    required this.onIncrease,
    required this.onDecrease,
    required this.hintText,
  });

  final TextEditingController controller;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: onDecrease,
          icon: const Icon(Icons.remove_circle_outline),
        ),
        Expanded(
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: hintText,
            ),
          ),
        ),
        IconButton(
          onPressed: onIncrease,
          icon: const Icon(Icons.add_circle_outline),
        ),
      ],
    );
  }
}
