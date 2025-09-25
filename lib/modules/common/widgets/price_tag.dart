import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PriceTag extends StatelessWidget {
  PriceTag({super.key, required this.amount, this.prefix});

  final double amount;
  final String? prefix;
  final NumberFormat formatter = NumberFormat.currency(symbol: '﷼');

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.4),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        '${prefix != null ? '$prefix ' : ''}${formatter.format(amount)}',
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
