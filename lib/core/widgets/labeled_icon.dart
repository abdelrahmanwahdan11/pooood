import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LabeledIcon extends StatelessWidget {
  const LabeledIcon({
    super.key,
    required this.icon,
    required this.label,
    this.value,
  });

  final IconData icon;
  final String label;
  final String? value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18),
        const SizedBox(width: 6),
        Text(
          label,
          style: Get.textTheme.bodySmall,
        ),
        if (value != null) ...[
          const SizedBox(width: 4),
          Text(
            value!,
            style: Get.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ],
    );
  }
}
