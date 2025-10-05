import 'package:get/get.dart';

import '../../main.dart';
import '../../models/locale_text.dart';
import '../../models/marketplace_meta.dart';

class TrustController extends GetxController {
  AppController get appController => Get.find<AppController>();

  List<TrustBadge> get badges => appController.trustBadges;
  List<MarketplacePolicy> get policies => appController.policies;
  List<MarketplaceReport> get reports => appController.reports;
  List<MarketplaceStory> get stories => appController.trustStories;
  List<Vendor> get vendors => appController.vendors;
  List<HighlightMetric> get highlights => appController.marketHighlights;
  List<LocaleText> get liveMoments => appController.liveMoments;
}
