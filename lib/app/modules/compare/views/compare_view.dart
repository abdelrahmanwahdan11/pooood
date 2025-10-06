import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/utils/layout_helper.dart';
import '../controllers/compare_controller.dart';

class CompareView extends GetView<CompareController> {
  const CompareView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text('home_compare'.tr)),
      body: LayoutHelper.constrain(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: controller.codeController,
                decoration: InputDecoration(
                  labelText: 'compare_code'.tr,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                ),
                keyboardType: TextInputType.number,
                maxLength: 6,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: FilledButton.tonal(
                      onPressed: controller.loadFriend,
                      child: Text('compare_load'.tr),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: controller.generateCode,
                      child: Text('compare_generate'.tr),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Obx(
                () {
                  final me = controller.myProfile.value;
                  final friend = controller.friendProfile.value;
                  if (me == null) return const SizedBox.shrink();
                  final traits = ['O', 'C', 'E', 'A', 'N'];
                  final labels = [
                    'trait_openness'.tr,
                    'trait_conscientiousness'.tr,
                    'trait_extraversion'.tr,
                    'trait_agreeableness'.tr,
                    'trait_neuroticism'.tr,
                  ];
                  final myValues = me.scores.toMap();
                  final friendValues = friend?.scores.toMap();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('compare_title'.tr, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 280,
                        child: BarChart(
                          BarChartData(
                            maxY: 100,
                            gridData: FlGridData(show: true, horizontalInterval: 20),
                            borderData: FlBorderData(show: false),
                            titlesData: FlTitlesData(
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    final index = value.toInt();
                                    if (index >= traits.length) return const SizedBox.shrink();
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: Text(labels[index], style: theme.textTheme.labelSmall),
                                    );
                                  },
                                ),
                              ),
                              leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, interval: 20)),
                              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            ),
                            barGroups: [
                              for (int i = 0; i < traits.length; i++)
                                BarChartGroupData(
                                  x: i,
                                  barsSpace: 8,
                                  barRods: [
                                    BarChartRodData(
                                      toY: (myValues[traits[i]] ?? 0).toDouble(),
                                      color: theme.colorScheme.primary,
                                      width: 16,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    if (friendValues != null)
                                      BarChartRodData(
                                        toY: (friendValues[traits[i]] ?? 0).toDouble(),
                                        color: theme.colorScheme.secondary,
                                        width: 16,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      if (friend != null) ...[
                        Text('compare_highlights'.tr, style: theme.textTheme.titleMedium),
                        const SizedBox(height: 12),
                        ...controller.highlights.toList().map(
                          (item) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text(item, style: theme.textTheme.bodyMedium),
                          ),
                        ),
                      ],
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
