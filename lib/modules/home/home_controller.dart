import 'package:get/get.dart';

class HomeController extends GetxController {
  final RxInt index = 0.obs;

  void changeTab(int value) {
    index.value = value;
  }
}
