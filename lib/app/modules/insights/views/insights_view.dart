import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/services/feature_service.dart';
import '../../../core/utils/layout_helper.dart';
import '../controllers/insights_controller.dart';

class InsightsView extends GetView<InsightsController> {
  const InsightsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final features = Get.find<FeatureService>();
    final quickMood = features.isEnabled('quick_mood');
    return Scaffold(
      body: LayoutHelper.constrain(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(24, 48, 24, 24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [theme.colorScheme.primary.withOpacity(0.18), theme.colorScheme.secondary.withOpacity(0.12)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(36)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SafeArea(
                    bottom: false,
                    child: Row(
                      children: [
                        IconButton(onPressed: Get.back, icon: const Icon(Icons.arrow_back_ios_new_rounded)),
                        Text('home_insights'.tr, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text('insights_intro'.tr, style: theme.textTheme.bodyLarge?.copyWith(color: theme.hintColor)),
                  if (quickMood) ...[
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 12,
                      children: [
                        for (final mood in ['emotions_joy', 'emotions_calm', 'emotions_anxiety'])
                          ActionChip(
                            label: Text(mood.tr),
                            onPressed: () {
                              controller.textController.text = mood.tr;
                              controller.send();
                            },
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Expanded(
                      child: Obx(
                        () {
                          if (controller.messages.isEmpty) {
                            return Center(
                              child: Text(
                                'insights_empty'.tr,
                                style: theme.textTheme.bodyLarge?.copyWith(color: theme.hintColor),
                                textAlign: TextAlign.center,
                              ),
                            );
                          }
                          return ListView.builder(
                            reverse: true,
                            itemCount: controller.messages.length,
                            itemBuilder: (context, index) {
                              final message = controller.messages[controller.messages.length - 1 - index];
                              final isUser = message.isUser;
                              return Align(
                                alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                                child: Container(
                                  margin: const EdgeInsets.symmetric(vertical: 8),
                                  padding: const EdgeInsets.all(16),
                                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                                  decoration: BoxDecoration(
                                    color: isUser ? theme.colorScheme.primary : theme.cardColor,
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  child: Text(
                                    message.text,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: isUser ? Colors.white : theme.colorScheme.onSurface,
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    Obx(
                      () {
                        final reading = controller.reading.value;
                        if (reading == null) return const SizedBox.shrink();
                        final values = {
                          'emotions_joy'.tr: reading.joy,
                          'emotions_sadness'.tr: reading.sadness,
                          'emotions_anger'.tr: reading.anger,
                          'emotions_anxiety'.tr: reading.anxiety,
                          'emotions_calm'.tr: reading.calm,
                        };
                        return Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: theme.cardColor,
                            borderRadius: BorderRadius.circular(28),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('feature_emotion_heatmap_title'.tr, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                              SizedBox(
                                height: 180,
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
                                            if (index >= values.length) return const SizedBox.shrink();
                                            return Padding(
                                              padding: const EdgeInsets.only(top: 8),
                                              child: Text(values.keys.elementAt(index), style: theme.textTheme.labelSmall),
                                            );
                                          },
                                        ),
                                      ),
                                      leftTitles: AxisTitles(
                                        sideTitles: SideTitles(showTitles: true, interval: 25),
                                      ),
                                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                    ),
                                    barGroups: [
                                      for (int i = 0; i < values.length; i++)
                                        BarChartGroupData(
                                          x: i,
                                          barRods: [
                                            BarChartRodData(
                                              toY: values.values.elementAt(i).toDouble(),
                                              color: theme.colorScheme.secondary,
                                              width: 18,
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                          ],
                                        )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
              color: Theme.of(context).colorScheme.surface,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller.textController,
                      onChanged: controller.updateInput,
                      decoration: InputDecoration(
                        hintText: 'insights_placeholder'.tr,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                        filled: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  FilledButton(
                    onPressed: controller.send,
                    style: FilledButton.styleFrom(padding: const EdgeInsets.all(18), shape: const CircleBorder()),
                    child: const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
