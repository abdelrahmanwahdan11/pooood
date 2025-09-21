import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/utils/currency_utils.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/glass_container.dart';
import 'alerts_controller.dart';

class AlertsView extends GetView<AlertsController> {
  const AlertsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: Get.locale?.languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text('price_alerts'.tr),
        ),
        body: Obx(
          () {
            if (controller.alerts.isEmpty) {
              return Center(child: Text('no_alerts'.tr));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(24),
              itemCount: controller.alerts.length,
              itemBuilder: (context, index) {
                final alert = controller.alerts[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: GlassContainer(
                    child: FutureBuilder(
                      future: controller.productFor(alert),
                      builder: (context, snapshot) {
                        final title = snapshot.data?.title ?? alert.productId;
                        return ListTile(
                          title: Text(title),
                          subtitle: Text('${'target_price'.tr}: ${formatCurrency(
                                alert.targetPrice,
                                locale: Get.locale?.languageCode ?? 'en',
                                currency: currentCurrency(),
                              )}'),
                          trailing: Switch(
                            value: alert.isActive,
                            onChanged: (_) => controller.toggleAlert(alert),
                          ),
                          onLongPress: () => controller.removeAlert(alert.id),
                        );
                      },
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
