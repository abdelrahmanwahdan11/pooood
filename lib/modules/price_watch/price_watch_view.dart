import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/utils/responsive.dart';
import '../../core/utils/time.dart';
import '../../core/widgets/glass_container.dart';
import '../../data/models/price_watch.dart';
import 'price_watch_controller.dart';

class PriceWatchView extends StatefulWidget {
  const PriceWatchView({super.key});

  @override
  State<PriceWatchView> createState() => _PriceWatchViewState();
}

class _PriceWatchViewState extends State<PriceWatchView>
    with AutomaticKeepAliveClientMixin {
  final controller = Get.find<PriceWatchController>();
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final categoryController = TextEditingController();
  final desiredPriceController = TextEditingController();
  final rangeController = TextEditingController(text: '0');
  final notesController = TextEditingController();
  final areasController = TextEditingController();
  final expiryController = TextEditingController();
  final contactController = TextEditingController();
  bool receiveAlerts = true;
  int? editingId;
  int editingMatches = 0;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final padding = Responsive.adaptivePadding(context);
    return Padding(
      padding: EdgeInsets.all(padding),
      child: Column(
        children: [
          GlassContainer(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('price_watch_intro'.tr,
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(labelText: 'title'.tr),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'required_field'.tr : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: categoryController,
                    decoration: InputDecoration(labelText: 'category'.tr),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: desiredPriceController,
                          decoration:
                              InputDecoration(labelText: 'desired_price'.tr),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: rangeController,
                          decoration:
                              InputDecoration(labelText: 'acceptable_range'.tr),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: areasController,
                    decoration: InputDecoration(labelText: 'preferred_areas'.tr),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: expiryController,
                    decoration: InputDecoration(labelText: 'expiry_date'.tr),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: contactController,
                    decoration:
                        InputDecoration(labelText: 'contact_preference'.tr),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: notesController,
                    decoration: InputDecoration(labelText: 'notes'.tr),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text('receive_alerts'.tr),
                      const Spacer(),
                      Switch(
                        value: receiveAlerts,
                        onChanged: (value) => setState(() => receiveAlerts = value),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FilledButton(
                      onPressed: _submit,
                      child: Text('save'.tr),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Obx(
              () => controller.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: controller.watches.length,
                      itemBuilder: (context, index) {
                        final watch = controller.watches[index];
                        final matched = watch.matches > 0;
                        return Dismissible(
                          key: ValueKey(watch.id),
                          background: Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            color: Colors.redAccent,
                            child: const Icon(Icons.delete, color: Colors.white),
                          ),
                          secondaryBackground: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            color: Colors.green,
                            child: const Icon(Icons.edit, color: Colors.white),
                          ),
                          confirmDismiss: (direction) async {
                            if (direction == DismissDirection.startToEnd) {
                              await controller.deleteWatch(watch.id);
                              return true;
                            } else {
                              _editWatch(watch);
                              return false;
                            }
                          },
                          child: GlassContainer(
                            margin: const EdgeInsets.only(bottom: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Chip(
                                      label: Text(
                                        matched ? 'matched'.tr : 'unmatched'.tr,
                                      ),
                                      backgroundColor: matched
                                          ? const Color(0xFF7BD597).withOpacity(0.25)
                                          : Colors.white.withOpacity(0.2),
                                    ),
                                    const Spacer(),
                                    Text('${watch.matches} ${'matches'.tr}'),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(watch.title,
                                    style:
                                        Theme.of(context).textTheme.titleMedium),
                                Text('${'desired_price'.tr}: ${watch.desiredPrice}'),
                                Text('${'preferred_areas'.tr}: ${watch.preferredAreas}'),
                                Text('${'expiry_date'.tr}: ${TimeUtils.formatDate(watch.expiryDate)}'),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  void _submit() async {
    if (!(formKey.currentState?.validate() ?? false)) return;
    final id = editingId ?? DateTime.now().millisecondsSinceEpoch;
    final watch = PriceWatch(
      id: id,
      title: titleController.text,
      category: categoryController.text,
      desiredPrice: double.tryParse(desiredPriceController.text) ?? 0,
      acceptableRange: double.tryParse(rangeController.text) ?? 0,
      notes: notesController.text,
      preferredAreas: areasController.text,
      expiryDate:
          DateTime.tryParse(expiryController.text) ?? DateTime.now().add(const Duration(days: 7)),
      contactPreference: contactController.text,
      receiveAlerts: receiveAlerts,
      matches: editingId != null ? editingMatches : 0,
    );
    if (editingId != null) {
      await controller.updateWatch(watch);
    } else {
      await controller.addWatch(watch);
    }
    editingId = null;
    editingMatches = 0;
    Get.snackbar('app_name'.tr, 'snackbar_saved'.tr);
    formKey.currentState?.reset();
  }

  void _editWatch(PriceWatch watch) {
    titleController.text = watch.title;
    categoryController.text = watch.category;
    desiredPriceController.text = watch.desiredPrice.toString();
    rangeController.text = watch.acceptableRange.toString();
    notesController.text = watch.notes;
    areasController.text = watch.preferredAreas;
    expiryController.text = watch.expiryDate.toIso8601String();
    contactController.text = watch.contactPreference;
    receiveAlerts = watch.receiveAlerts;
    editingId = watch.id;
    editingMatches = watch.matches;
    setState(() {});
  }

  @override
  void dispose() {
    titleController.dispose();
    categoryController.dispose();
    desiredPriceController.dispose();
    rangeController.dispose();
    notesController.dispose();
    areasController.dispose();
    expiryController.dispose();
    contactController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
