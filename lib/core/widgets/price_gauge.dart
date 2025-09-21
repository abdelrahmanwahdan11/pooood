import 'package:flutter/material.dart';

import '../theme/green_theme.dart';

class PriceGauge extends StatelessWidget {
  const PriceGauge({
    super.key,
    required this.confidence,
    this.label,
  });

  final double confidence;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final normalized = confidence.clamp(0.0, 1.0);
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label ?? 'Confidence',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '${(normalized * 100).toStringAsFixed(0)}%',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: GreenPalette.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 12,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            color: Colors.white.withOpacity(0.4),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: constraints.maxWidth * normalized,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    gradient: GreenTheme.primaryGradient,
                    boxShadow: [
                      BoxShadow(
                        color: GreenPalette.primary.withOpacity(0.25),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
