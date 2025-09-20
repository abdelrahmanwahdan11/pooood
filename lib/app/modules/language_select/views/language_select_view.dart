import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../localization/translations.dart';
import '../../../theme/glass_widgets.dart';
import '../controllers/language_select_controller.dart';

class LanguageSelectView extends GetView<LanguageSelectController> {
  const LanguageSelectView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locales = AppTranslations.supportedLocales;

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF181B2C), Color(0xFF2E335A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('appName'.tr, style: theme.textTheme.headlineMedium?.copyWith(color: Colors.white)),
                const SizedBox(height: 24),
                Text('language.title'.tr, style: theme.textTheme.titleLarge?.copyWith(color: Colors.white)),
                const SizedBox(height: 8),
                Text('language.subtitle'.tr, style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70)),
                const SizedBox(height: 32),
                Expanded(
                  child: Obx(
                    () => ListView.separated(
                      itemCount: locales.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 18),
                      itemBuilder: (_, index) {
                        final locale = locales[index];
                        final isSelected = controller.selectedLocale.value == locale;
                        final title = locale.languageCode == 'ar' ? 'language.arabic'.tr : 'language.english'.tr;
                        final direction = locale.languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr;
                        return GlassCard(
                          onTap: () => controller.selectLocale(locale),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeOut,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected ? theme.colorScheme.primary : Colors.white24,
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
                            child: Row(
                              children: [
                                Container(
                                  width: 46,
                                  height: 46,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white30),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(locale.languageCode.toUpperCase(), style: theme.textTheme.titleMedium?.copyWith(color: Colors.white)),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Directionality(
                                    textDirection: direction,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(title, style: theme.textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w600)),
                                        const SizedBox(height: 4),
                                        Text(
                                          locale.languageCode == 'ar' ? 'العربية الفصحى الحديثة' : 'Modern standard English',
                                          style: theme.textTheme.bodySmall?.copyWith(color: Colors.white70),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  width: 26,
                                  height: 26,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isSelected ? theme.colorScheme.primary : Colors.transparent,
                                    border: Border.all(color: isSelected ? theme.colorScheme.primary : Colors.white38, width: 2),
                                  ),
                                  child: isSelected
                                      ? const Icon(Icons.check, size: 16, color: Colors.white)
                                      : null,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      backgroundColor: Colors.white,
                      foregroundColor: theme.colorScheme.primary,
                      textStyle: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    onPressed: controller.proceed,
                    child: Text('continue'.tr),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
