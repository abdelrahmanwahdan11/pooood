import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'glass_container.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({super.key, this.icon = Icons.inbox_outlined});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GlassContainer(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 12),
            Text(
              'empty_state_title'.tr,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'empty_state_body'.tr,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
