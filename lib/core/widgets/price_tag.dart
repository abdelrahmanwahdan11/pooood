import 'package:flutter/material.dart';

class PriceTag extends StatelessWidget {
  const PriceTag({
    super.key,
    required this.price,
    this.currency = 'USD',
    this.highlight = false,
  });

  final double price;
  final String currency;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = highlight ? theme.colorScheme.secondary : theme.colorScheme.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        '${price.toStringAsFixed(0)} $currency',
        style: theme.textTheme.titleSmall?.copyWith(color: color),
      ),
    );
  }
}
