import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/routing/app_routes.dart';
import '../../core/widgets/product_card.dart';
import 'search_controller.dart';

class SearchView extends GetView<SearchController> {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: Get.locale?.languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: TextField(
            autofocus: true,
            onChanged: controller.onQueryChanged,
            decoration: InputDecoration(
              hintText: 'search_hint'.tr,
              border: InputBorder.none,
            ),
            onSubmitted: (value) {
              controller.saveToHistory(value);
              controller.search(value);
            },
          ),
        ),
        body: Obx(
          () {
            if (controller.query.isEmpty) {
              return _SearchSuggestions(controller: controller);
            }
            if (controller.isSearching.value) {
              return const Center(child: CircularProgressIndicator());
            }
            if (controller.results.isEmpty) {
              return Center(child: Text('empty_state'.tr));
            }
            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.72,
              ),
              itemCount: controller.results.length,
              itemBuilder: (context, index) {
                final product = controller.results[index];
                return ProductCard(
                  product: product,
                  showTrend: true,
                  onTap: () => Get.toNamed('${AppRoutes.product}/${product.id}'),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _SearchSuggestions extends StatelessWidget {
  const _SearchSuggestions({required this.controller});

  final SearchController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text('recent_searches'.tr, style: theme.textTheme.titleMedium),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          children: controller.history
              .map(
                (item) => ActionChip(
                  label: Text(item),
                  onPressed: () {
                    controller.onQueryChanged(item);
                    controller.search(item);
                  },
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 24),
        Text('suggested'.tr, style: theme.textTheme.titleMedium),
        const SizedBox(height: 12),
        ...controller.suggestions.map(
          (suggestion) => ListTile(
            title: Text(suggestion),
            trailing: const Icon(Icons.north_west),
            onTap: () {
              controller.onQueryChanged(suggestion);
              controller.search(suggestion);
            },
          ),
        ),
      ],
    );
  }
}
