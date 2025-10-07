import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import '../../../core/services/feature_service.dart';
import '../../../core/utils/layout_helper.dart';
import '../controllers/quiz_controller.dart';

class QuizView extends GetView<QuizController> {
  const QuizView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final features = Get.find<FeatureService>();
    final isReducedMotion = features.toggles['reduced_motion'] ?? false;
    final showTips = features.isEnabled('quiz_tips');
    return Scaffold(
      body: SafeArea(
        child: LayoutHelper.constrain(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(onPressed: Get.back, icon: const Icon(Icons.arrow_back_ios_new_rounded)),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('home_quiz'.tr, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                          Obx(
                            () => Text(
                              'question_of'.trParams({
                                'current': (controller.currentIndex.value + 1).toString(),
                                'total': controller.total.toString(),
                              }),
                              style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        final current = features.toggles['focus_mode'] ?? false;
                        await features.toggle('focus_mode', !current);
                      },
                      icon: Icon(
                        features.toggles['focus_mode'] == true ? Icons.visibility_off : Icons.visibility,
                      ),
                      tooltip: 'feature_focus_mode_title'.tr,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        theme.colorScheme.secondary.withOpacity(0.3),
                        theme.colorScheme.primary.withOpacity(0.15),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(36),
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    children: [
                      Obx(
                        () => TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0, end: controller.progress),
                          duration: Duration(milliseconds: isReducedMotion ? 0 : 600),
                          builder: (context, value, _) {
                            return SizedBox(
                              height: 110,
                              width: 110,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  CircularProgressIndicator(
                                    value: value == 0 && controller.answers.isEmpty ? null : value,
                                    strokeWidth: 10,
                                    backgroundColor: Colors.white.withOpacity(0.3),
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text('${(value * 100).round()}%', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                                      Text('results_title'.tr, style: theme.textTheme.labelSmall),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Obx(
                          () => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                controller.currentQuestion.localized(Get.locale?.languageCode ?? 'en'),
                                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                              ),
                              if (showTips)
                                Padding(
                                  padding: const EdgeInsets.only(top: 12),
                                  child: Text(
                                    controller.currentQuestion.reverseScored
                                        ? 'feature_reverse_helper_desc'.tr
                                        : 'feature_quiz_tips_desc'.tr,
                                    style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
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
                          _LikertScale(
                            value: controller.selectedValue(question.id),
                            onChanged: controller.selectAnswer,
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: controller.previous,
                                  icon: const Icon(Icons.arrow_back),
                                  label: Text('previous'.tr),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () => Get.back(),
                                  icon: const Icon(Icons.save_outlined),
                                  label: Text('save_exit'.tr),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: FilledButton.icon(
                                  onPressed: controller.next,
                                  icon: const Icon(Icons.arrow_forward),
                                  label: Text('next'.tr),
                                ),
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
    final theme = Theme.of(context);
    final labels = [
      'likert_1'.tr,
      'likert_2'.tr,
      'likert_3'.tr,
      'likert_4'.tr,
      'likert_5'.tr,
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: List.generate(5, (index) {
        final selected = value == index + 1;
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 260),
            curve: Curves.easeOut,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              color: selected ? theme.colorScheme.primary : theme.cardColor,
              border: Border.all(color: theme.colorScheme.primary.withOpacity(selected ? 0.0 : 0.12)),
              boxShadow: selected
                  ? [
                      BoxShadow(
                        color: theme.colorScheme.primary.withOpacity(0.25),
                        blurRadius: 18,
                        offset: const Offset(0, 10),
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 12,
                        offset: const Offset(0, 8),
                      ),
                    ],
            ),
            child: ListTile(
              title: Text(
                labels[index],
                style: theme.textTheme.titleMedium?.copyWith(color: selected ? Colors.white : null, fontWeight: FontWeight.w600),
              ),
              trailing: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: selected ? 1 : 0,
                child: const Icon(Icons.check_circle, color: Colors.white),
              ),
              onTap: () => onChanged(index + 1),
            ),
          ),
        );
      }),
    );
  }
}
