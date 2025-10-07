import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import '../../../core/utils/layout_helper.dart';
import '../controllers/quiz_controller.dart';

class QuizView extends GetView<QuizController> {
  const QuizView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text('home_quiz'.tr)),
      body: LayoutHelper.constrain(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Obx(
                () => TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: controller.progress),
                  duration: const Duration(milliseconds: 600),
                  builder: (context, value, child) {
                    return SizedBox(
                      height: 120,
                      width: 120,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CircularProgressIndicator(
                            value: value,
                            strokeWidth: 10,
                            backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                          ),
                          Text('${(value * 100).round()}%'),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Obx(
                () => Text(
                  'question_of'.trParams({
                    'current': (controller.currentIndex.value + 1).toString(),
                    'total': controller.total.toString(),
                  }),
                  style: theme.textTheme.titleMedium,
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: Obx(
                  () {
                    final question = controller.currentQuestion;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          question.localized(Get.locale?.languageCode ?? 'en'),
                          style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
                        ).animate().fade(duration: 300.ms).move(begin: const Offset(0, 12)),
                        const SizedBox(height: 24),
                        _LikertScale(
                          value: controller.selectedValue(question.id),
                          onChanged: controller.selectAnswer,
                        ),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: controller.previous,
                              child: Text('previous'.tr),
                            ),
                            TextButton(
                              onPressed: () => Get.back(),
                              child: Text('save_exit'.tr),
                            ),
                            TextButton(
                              onPressed: controller.next,
                              child: Text('next'.tr),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
              Obx(
                () => FilledButton(
                  onPressed: controller.isSubmitting.value ? null : controller.submit,
                  style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(56)),
                  child: controller.isSubmitting.value
                      ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(strokeWidth: 2))
                      : Text('submit'.tr),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LikertScale extends StatelessWidget {
  const _LikertScale({required this.value, required this.onChanged});

  final int? value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final labels = [
      'likert_1'.tr,
      'likert_2'.tr,
      'likert_3'.tr,
      'likert_4'.tr,
      'likert_5'.tr,
    ];
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: List.generate(5, (index) {
        final selected = value == index + 1;
        return ChoiceChip(
          label: SizedBox(
            width: 140,
            child: Text(labels[index], textAlign: TextAlign.center),
          ),
          selected: selected,
          onSelected: (_) => onChanged(index + 1),
          selectedColor: Theme.of(context).colorScheme.primary,
          labelStyle: TextStyle(color: selected ? Colors.white : null),
        );
      }),
    );
  }
}
