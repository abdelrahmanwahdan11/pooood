import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/emotion_reading.dart';
import '../../../data/repositories/insights_repository.dart';

class InsightsController extends GetxController {
  InsightsController(this._repository);

  final InsightsRepository _repository;
  final messages = <InsightMessage>[].obs;
  final reading = Rxn<EmotionReading>();
  final input = ''.obs;
  late final TextEditingController textController;

  @override
  void onInit() {
    textController = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    textController.dispose();
    super.onClose();
  }

  void updateInput(String value) => input.value = value;

  Future<void> send() async {
    final text = input.value.trim();
    if (text.isEmpty) return;
    messages.add(InsightMessage(text: text, isUser: true));
    input.value = '';
    textController.clear();
    await Future.delayed(const Duration(milliseconds: 200));
    final result = _repository.analyse(text);
    reading.value = result;
    messages.add(
      InsightMessage(
        text: _buildResponse(result),
        isUser: false,
      ),
    );
  }

  String _buildResponse(EmotionReading reading) {
    final dominant = <String, int>{
      'emotions_joy': reading.joy,
      'emotions_sadness': reading.sadness,
      'emotions_anger': reading.anger,
      'emotions_anxiety': reading.anxiety,
      'emotions_calm': reading.calm,
    };
    final sorted = dominant.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final primary = sorted.first.key.tr;
    return 'chatbot_label'.trParams({'emotion': primary});
  }
}

class InsightMessage {
  InsightMessage({required this.text, required this.isUser});

  final String text;
  final bool isUser;
}
