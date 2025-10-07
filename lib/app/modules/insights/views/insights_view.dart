import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/utils/layout_helper.dart';
import '../controllers/insights_controller.dart';

class InsightsView extends GetView<InsightsController> {
  const InsightsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text('home_insights'.tr)),
      body: LayoutHelper.constrain(
        child: Column(
          children: [
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
                                    borderRadius: BorderRadius.circular(20),
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
                    const SizedBox(height: 24),
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
                        return SizedBox(
                          height: 200,
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
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
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
