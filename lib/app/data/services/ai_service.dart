/*
  هذا الملف يحاكي خدمة الذكاء الاصطناعي ويولّد تحليلات ثابتة للعناصر كل 8 ثوانٍ.
  يمكن تطويره لاستبدال التحليلات المحلية باتصال فعلي مع خوادم ذكية عند توفرها.
*/
import 'package:get/get.dart';

class AiService extends GetxService {
  static AiService get to => Get.find<AiService>();

  List<String> getAiInfoForItem(String itemId) {
    final base = itemId.hashCode.abs();
    final quality = (base % 5) + 1;
    final demand = (base % 3) + 1;
    final rarity = (base % 7) + 1;
    return [
      'ai.summary_$quality',
      'ai.demand_$demand',
      'ai.rarity_$rarity',
      'ai.tip_${(base % 4) + 1}',
      'ai.warning_${(base % 2) + 1}',
    ];
  }
}
