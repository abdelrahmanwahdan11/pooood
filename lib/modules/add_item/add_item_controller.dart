import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddItemController extends GetxController {
  final auctionFormKey = GlobalKey<FormState>();
  final discountFormKey = GlobalKey<FormState>();

  final auctionTitleController = TextEditingController();
  final discountTitleController = TextEditingController();

  void submitAuction() {
    if (!auctionFormKey.currentState!.validate()) return;
    Get.snackbar('add_auction'.tr, 'submit'.tr);
  }

  void submitDiscount() {
    if (!discountFormKey.currentState!.validate()) return;
    Get.snackbar('add_discount'.tr, 'submit'.tr);
  }
}
