import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/utils/responsive.dart';
import '../common/widgets/glass_container.dart';
import '../common/widgets/section_header.dart';
import 'price_watch_controller.dart';

class PriceWatchView extends GetView<PriceWatchController> {
  const PriceWatchView({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Responsive.sizeOf(constraints);
        final padding = EdgeInsets.symmetric(
          vertical: 16,
          horizontal: Responsive.horizontalPadding(size),
        );
        return SingleChildScrollView(
          padding: padding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionHeader(title: 'price_watch_tab'.tr),
              Obx(
                () => Column(
                  children: controller.watches
                      .map(
                        (watch) => GlassContainer(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      watch.productName,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 4),
                                    Text('${'target_price'.tr}: ﷼${watch.targetPrice.toStringAsFixed(0)}'),
                                    if (watch.notes.isNotEmpty) ...[
                                      const SizedBox(height: 4),
                                      Text(watch.notes,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall),
                                    ]
                                  ],
                                ),
                              ),
                              Switch(value: watch.isActive, onChanged: (_) {}),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(height: 24),
              SectionHeader(title: 'add_watch'.tr),
              GlassContainer(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: controller.productController,
                        decoration: InputDecoration(labelText: 'product_name'.tr),
                        validator: (value) =>
                            value == null || value.trim().isEmpty ? 'required' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: controller.priceController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(labelText: 'target_price'.tr),
                        validator: (value) =>
                            double.tryParse(value ?? '') == null ? 'invalid_number' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: controller.notesController,
                        decoration: InputDecoration(labelText: 'notes_optional'.tr),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: controller.addWatch,
                          child: Text('submit'.tr),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
