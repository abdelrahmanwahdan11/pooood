import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/compare_profile.dart';
import '../../../data/models/ocean_score.dart';
import '../../../data/repositories/compare_repository.dart';

class CompareController extends GetxController {
  CompareController(this._repository);

  final CompareRepository _repository;
  late final TextEditingController codeController;
  final myProfile = Rxn<CompareProfile>();
  final friendProfile = Rxn<CompareProfile>();
  final highlights = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    codeController = TextEditingController();
    _initProfile();
  }

  void _initProfile() {
    myProfile.value = CompareProfile(
      code: '000000',
      displayName: 'You',
      scores: const OceanScore(
        openness: 68,
        conscientiousness: 70,
        extraversion: 58,
        agreeableness: 75,
        neuroticism: 42,
      ),
    );
  }

  @override
  void onClose() {
    codeController.dispose();
    super.onClose();
  }

  void generateCode() {
    final profile = myProfile.value!;
    final newCode = _repository.generateCode();
    final updated = CompareProfile(code: newCode, scores: profile.scores, displayName: profile.displayName);
    myProfile.value = updated;
    _repository.saveProfile(updated);
    Get.snackbar('compare_title'.tr, '${'compare_code'.tr}: $newCode', snackPosition: SnackPosition.BOTTOM);
  }

  void loadFriend() {
    final code = codeController.text.trim();
    if (code.length != 6) {
      Get.snackbar('compare_title'.tr, 'compare_code'.tr, snackPosition: SnackPosition.BOTTOM);
      return;
    }
    final profile = _repository.getByCode(code);
    if (profile == null) {
      Get.snackbar('compare_title'.tr, 'compare_friend_placeholder'.tr, snackPosition: SnackPosition.BOTTOM);
      return;
    }
    friendProfile.value = profile;
    _buildHighlights();
  }

  void _buildHighlights() {
    final mine = myProfile.value;
    final friend = friendProfile.value;
    if (mine == null || friend == null) return;
    highlights.clear();
    final pairs = {
      'trait_openness': [mine.scores.openness, friend.scores.openness],
      'trait_conscientiousness': [mine.scores.conscientiousness, friend.scores.conscientiousness],
      'trait_extraversion': [mine.scores.extraversion, friend.scores.extraversion],
      'trait_agreeableness': [mine.scores.agreeableness, friend.scores.agreeableness],
      'trait_neuroticism': [mine.scores.neuroticism, friend.scores.neuroticism],
    };
    pairs.forEach((key, values) {
      final leader = values[0] == values[1]
          ? 'compare_equal'.tr
          : values[0] > values[1]
              ? 'compare_you'.tr
              : 'compare_friend'.tr;
      highlights.add('${key.tr} • $leader');
    });
  }
}
