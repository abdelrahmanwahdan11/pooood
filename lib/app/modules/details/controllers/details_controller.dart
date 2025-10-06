/*
  هذا الملف يدير منطق صفحة التفاصيل بما في ذلك دوران معلومات الذكاء الاصطناعي والتفاعل.
  يمكن تطويره لإضافة مزيد من مؤشرات التحليل أو التكامل مع دردشة مباشرة.
*/
import 'dart:async';

import 'package:get/get.dart';

import '../../../data/models/item_model.dart';
import '../../../data/services/ai_service.dart';

class DetailsController extends GetxController {
  final ItemModel item;
  final aiInfos = <String>[].obs;
  final currentIndex = 0.obs;
  final isPaused = false.obs;

  Timer? _timer;

  DetailsController({required this.item});

  @override
  void onInit() {
    super.onInit();
    aiInfos.assignAll(AiService.to.getAiInfoForItem(item.id));
    _startTimer();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 8), (_) {
      if (isPaused.value || aiInfos.isEmpty) return;
      nextInfo();
    });
  }

  void nextInfo() {
    if (aiInfos.isEmpty) return;
    currentIndex.value = (currentIndex.value + 1) % aiInfos.length;
  }

  void previousInfo() {
    if (aiInfos.isEmpty) return;
    currentIndex.value = (currentIndex.value - 1 + aiInfos.length) % aiInfos.length;
  }

  void togglePause() {
    isPaused.value = !isPaused.value;
  }
}
