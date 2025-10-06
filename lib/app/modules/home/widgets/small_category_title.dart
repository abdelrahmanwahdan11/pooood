/*
  هذا الملف يرسم عنوان الفئة الصغير مع مؤشر التحديد للمساعدة في التنقل بين الصفحات.
  يمكن تطويره لدعم شارات أو عدادات مخصصة لكل فئة.
*/
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SmallCategoryTitle extends StatelessWidget {
  final String titleKey;
  final bool isActive;

  const SmallCategoryTitle({super.key, required this.titleKey, required this.isActive});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? theme.colorScheme.primary.withOpacity(0.2) : Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: isActive ? theme.colorScheme.primary : theme.dividerColor),
      ),
      child: Text(titleKey.tr,
          style: theme.textTheme.titleMedium?.copyWith(
            color: isActive ? theme.colorScheme.primary : theme.textTheme.bodyMedium?.color,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          )),
    );
  }
}
