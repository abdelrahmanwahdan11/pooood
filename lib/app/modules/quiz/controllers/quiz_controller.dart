import 'package:get/get.dart';

import '../../../data/models/ocean_score.dart';
import '../../../data/models/question.dart';
import '../../../data/models/trait.dart';
import '../../../data/repositories/quiz_repository.dart';
import '../../../routes/app_routes.dart';

class QuizController extends GetxController {
  QuizController(this._repository);

  final QuizRepository _repository;
  late final List<Question> questions;
  final currentIndex = 0.obs;
  final answers = <String, int>{}.obs;
  final isSubmitting = false.obs;

  int get total => questions.length;
  Question get currentQuestion => questions[currentIndex.value];
  double get progress => (answers.length / total).clamp(0, 1);

  @override
  void onInit() {
    questions = _repository.getQuestions();
    super.onInit();
  }

  void selectAnswer(int value) {
    answers[currentQuestion.id] = value;
    answers.refresh();
  }

  bool hasAnswer(String id) => answers.containsKey(id);

  int? selectedValue(String id) => answers[id];

  void next() {
    if (currentIndex.value < total - 1) {
      currentIndex.value++;
    }
  }

  void previous() {
    if (currentIndex.value > 0) {
      currentIndex.value--;
    }
  }

  Future<void> submit() async {
    if (answers.length < total) {
      Get.snackbar('home_quiz'.tr, 'continue_quiz'.tr, snackPosition: SnackPosition.BOTTOM);
      return;
    }
    isSubmitting.value = true;
    await Future.delayed(const Duration(milliseconds: 600));
    final score = _computeScore();
    isSubmitting.value = false;
    Get.toNamed(AppRoutes.results, arguments: score);
  }

  OceanScore _computeScore() {
    final traitScores = <Trait, List<int>>{};
    for (final question in questions) {
      traitScores.putIfAbsent(question.trait, () => []);
      final value = answers[question.id] ?? 3;
      final adjusted = question.reverseScored ? 6 - value : value;
      traitScores[question.trait]!.add(adjusted);
    }

    int normalize(List<int> values) {
      if (values.isEmpty) return 0;
      final average = values.reduce((a, b) => a + b) / values.length;
      final normalized = ((average - 1) / 4) * 100;
      return normalized.clamp(0, 100).round();
    }

    return OceanScore(
      openness: normalize(traitScores[Trait.openness] ?? []),
      conscientiousness: normalize(traitScores[Trait.conscientiousness] ?? []),
      extraversion: normalize(traitScores[Trait.extraversion] ?? []),
      agreeableness: normalize(traitScores[Trait.agreeableness] ?? []),
      neuroticism: normalize(traitScores[Trait.neuroticism] ?? []),
    );
  }
}
