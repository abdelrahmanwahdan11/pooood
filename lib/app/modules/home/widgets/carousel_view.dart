/*
  هذا الملف ينشئ أداة عرض شرائح محلية بديلة لحزمة carousel_view مع PageView.
  يمكن تطويره لاحقاً لدعم مؤشرات مخصصة أو تشغيل تلقائي.
*/
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/item_model.dart';

class CarouselView extends StatefulWidget {
  final List<ItemModel> items;
  final ValueChanged<ItemModel>? onTap;

  const CarouselView({super.key, required this.items, this.onTap});

  @override
  State<CarouselView> createState() => _CarouselViewState();
}

class _CarouselViewState extends State<CarouselView> {
  final controller = PageController(viewportFraction: 0.8);
  int currentIndex = 0;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (widget.items.isEmpty) {
      return Center(child: Text('home.empty'.tr));
    }
    return Column(
      children: [
        SizedBox(
          height: 180,
          child: PageView.builder(
            controller: controller,
            itemCount: widget.items.length,
            onPageChanged: (index) => setState(() => currentIndex = index),
            itemBuilder: (context, index) {
              final item = widget.items[index];
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: NetworkImage(item.images.isNotEmpty ? item.images.first : 'https://picsum.photos/seed/${item.id}/400/200'),
                    fit: BoxFit.cover,
                  ),
                  boxShadow: [
                    BoxShadow(color: theme.shadowColor.withOpacity(0.15), blurRadius: 8, offset: const Offset(0, 4)),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: widget.onTap == null ? null : () => widget.onTap!(item),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.black.withOpacity(0.1), Colors.black.withOpacity(0.7)],
                        ),
                      ),
                      alignment: Alignment.bottomLeft,
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        Get.locale?.languageCode == 'ar' ? item.titleAr : item.titleEn,
                        style: theme.textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.items.length, (index) {
            final active = index == currentIndex;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: active ? 16 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: active ? theme.colorScheme.primary : theme.colorScheme.primary.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
            );
          }),
        ),
      ],
    );
  }
}
