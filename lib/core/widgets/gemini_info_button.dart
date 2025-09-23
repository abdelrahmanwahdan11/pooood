import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/models/product.dart';
import '../../services/gemini_service.dart';
import 'gradient_glass_card.dart';

class GeminiInfoButton extends StatelessWidget {
  const GeminiInfoButton({
    super.key,
    required this.product,
  });

  final Product product;

  Future<void> _showSummary(BuildContext context) async {
    final service = Get.find<GeminiService>();
    final summary = await service.summaryForProduct(product);
    if (summary == null) {
      Get.snackbar(
        'gemini'.tr,
        'Unable to retrieve summary right now. Please try again later.',
      );
      return;
    }
    Get.bottomSheet(
      GradientGlassCard(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                product.title,
                style: Get.textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              Text(
                summary,
                style: Get.textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Get.back(),
                  child: Text('close'.tr),
                ),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'gemini'.tr,
      onPressed: () => _showSummary(context),
      icon: const Icon(Icons.auto_awesome_rounded),
      color: Colors.white,
    );
  }
}
