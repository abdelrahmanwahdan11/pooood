import 'package:flutter/material.dart';

import '../theme/glass_theme.dart';
import 'glass_container.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    this.filled = true,
  });

  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = filled ? theme.colorScheme.onPrimary : theme.colorScheme.primary;
    final bgColor = filled
        ? theme.colorScheme.primary.withOpacity(0.85)
        : theme.colorScheme.primary.withOpacity(0.08);

    return GestureDetector(
      onTap: onPressed,
      child: GlassContainer(
        style: GlassContainerStyle(
          blur: 24,
          opacity: filled ? 0.3 : 0.12,
          gradient: LinearGradient(
            colors: [bgColor, bgColor.withOpacity(0.6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: theme.colorScheme.primary.withOpacity(0.2)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null)
              Icon(
                icon,
                size: 20,
                color: textColor,
              ),
            if (icon != null) const SizedBox(width: 8),
            Text(
              label,
              style: theme.textTheme.titleMedium?.copyWith(color: textColor),
            ),
          ],
        ),
      ),
    );
  }
}
