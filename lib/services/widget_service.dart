import 'package:home_widget/home_widget.dart';

class WidgetService {
  static const String widgetName = 'BidGlassWidget';
  static const String widgetProvider = 'BidGlassWidgetProvider';

  static Future<void> initialize() async {
    await HomeWidget.setAppGroupId('bidglass_group');
  }

  Future<void> updateSelectedAuction({required String id, required String title}) async {
    await HomeWidget.saveWidgetData<String>('selected_auction_id', id);
    await HomeWidget.saveWidgetData<String>('selected_auction_title', title);
    await HomeWidget.updateWidget(name: widgetName, iOSName: widgetProvider);
  }
}
