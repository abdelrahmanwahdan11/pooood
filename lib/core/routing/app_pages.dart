import 'package:get/get.dart';

import '../../modules/add_item/add_item_binding.dart';
import '../../modules/add_item/add_item_view.dart';
import '../../modules/my_activity/my_activity_binding.dart';
import '../../modules/my_activity/my_activity_view.dart';
import '../../modules/notifications/notifications_binding.dart';
import '../../modules/notifications/notifications_view.dart';
import '../../modules/shell/shell_binding.dart';
import '../../modules/shell/shell_view.dart';
import 'app_routes.dart';

class AppPages {
  static final routes = <GetPage<dynamic>>[
    GetPage(
      name: AppRoutes.shell,
      page: ShellView.new,
      binding: ShellBinding(),
    ),
    GetPage(
      name: AppRoutes.notifications,
      page: NotificationsView.new,
      binding: NotificationsBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.addItem,
      page: AddItemView.new,
      binding: AddItemBinding(),
      transition: Transition.downToUp,
    ),
    GetPage(
      name: AppRoutes.myActivity,
      page: MyActivityView.new,
      binding: MyActivityBinding(),
      transition: Transition.fadeIn,
    ),
  ];
}
