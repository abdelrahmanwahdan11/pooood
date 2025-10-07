import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import '../../../core/services/feature_service.dart';
import '../../../core/utils/layout_helper.dart';
import '../../../data/models/trait.dart';
import '../controllers/results_controller.dart';

class ResultsView extends GetView<ResultsController> {
  const ResultsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final features = Get.find<FeatureService>();
    final enableExport = features.isEnabled('export_pdf');
    return Scaffold(
      body: SafeArea(
        child: LayoutHelper.constrain(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(onPressed: Get.back, icon: const Icon(Icons.arrow_back_ios_new_rounded)),
                    Text('results_title'.tr, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 24),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [theme.colorScheme.primary.withOpacity(0.12), theme.colorScheme.tertiary.withOpacity(0.2)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(36),
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('results_intro'.tr, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 260,
                        child: BarChart(
                          BarChartData(
                            maxY: 100,
                            barTouchData: BarTouchData(enabled: true),
                            titlesData: FlTitlesData(
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: true, interval: 20),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    final index = value.toInt();
                                    if (index >= controller.items.length) return const SizedBox.shrink();
                                    final trait = controller.items[index].trait;
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 12),
                                      child: Text(trait.localizationKey.tr, style: theme.textTheme.labelMedium),
                                    );
                                  },
                                ),
                              ),
                              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            ),
                            gridData: FlGridData(show: true, horizontalInterval: 20),
                            borderData: FlBorderData(show: false),
                            barGroups: [
                              for (int i = 0; i < controller.items.length; i++)
                                BarChartGroupData(
                                  x: i,
                                  barRods: [
                                    BarChartRodData(
                                      toY: controller.items[i].value.toDouble(),
                                      width: 24,
                                      borderRadius: BorderRadius.circular(18),
                                      color: theme.colorScheme.primary,
                                      gradient: LinearGradient(
                                        colors: [theme.colorScheme.primary, theme.colorScheme.secondary],
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                      ),
                                    ),
                                  ],
                                )
                            ],
                          ),
                          swapAnimationDuration: const Duration(milliseconds: 600),
                          swapAnimationCurve: Curves.easeOut,
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 600.ms).move(begin: const Offset(0, 16)),
                const SizedBox(height: 32),
                Text('tips_title'.tr, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                ...controller.items.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _TraitTile(trait: item.trait),
                  ),
                ),
                const SizedBox(height: 24),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    FilledButton.tonalIcon(
                      onPressed: () {},
                      icon: const Icon(Icons.ios_share),
                      label: Text('results_share'.tr),
                    ),
                    if (enableExport)
                      FilledButton.tonalIcon(
                        onPressed: () {},
                        icon: const Icon(Icons.picture_as_pdf),
                        label: Text('feature_export_pdf_title'.tr),
                      ),
                    FilledButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.bookmark_added_outlined),
                      label: Text('results_save'.tr),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TraitTile extends StatelessWidget {
  const _TraitTile({required this.trait});

  final Trait trait;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 18,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            trait.localizationKey.tr,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text('tips_${trait.key}'.tr),
        ],
      ),
    ).animate().fade(duration: 400.ms).move(begin: const Offset(0, 12));
  }
}
