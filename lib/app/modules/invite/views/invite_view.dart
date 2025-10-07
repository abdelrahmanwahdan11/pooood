import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/repositories/compare_repository.dart';
import '../controllers/invite_controller.dart';

class InviteView extends GetView<InviteController> {
  const InviteView({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = Get.find<CompareRepository>();
    return Scaffold(
      appBar: AppBar(title: Text('invite_title'.tr)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 32),
            Text('invite_description'.tr, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 32),
            Obx(
              () => Text(
                controller.generatedCode.value,
                style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () {
                final code = repository.generateCode();
                controller.generatedCode.value = code;
              },
              child: Text('compare_generate'.tr),
            ),
          ],
        ),
      ),
    );
  }
}
