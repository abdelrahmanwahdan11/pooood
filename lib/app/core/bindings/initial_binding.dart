import 'package:get/get.dart';

import '../../data/repositories/compare_repository.dart';
import '../../data/repositories/insights_repository.dart';
import '../../data/repositories/quiz_repository.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QuizRepository>(() => QuizRepository(), fenix: true);
    Get.lazyPut<InsightsRepository>(() => InsightsRepository(), fenix: true);
    Get.lazyPut<CompareRepository>(() => CompareRepository(), fenix: true);
  }
}
