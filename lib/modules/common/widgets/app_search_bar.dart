import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'glass_container.dart';

class AppSearchBar extends StatefulWidget {
  const AppSearchBar({
    super.key,
    this.onChanged,
    this.onFiltersTap,
  });

  final ValueChanged<String>? onChanged;
  final VoidCallback? onFiltersTap;

  @override
  State<AppSearchBar> createState() => _AppSearchBarState();
}

class _AppSearchBarState extends State<AppSearchBar> {
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 320), () {
      widget.onChanged?.call(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          const Icon(Icons.search, size: 22),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              onChanged: _onChanged,
              decoration: InputDecoration(
                hintText: 'search_hint'.tr,
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.tune_rounded),
            onPressed: widget.onFiltersTap,
          ),
        ],
      ),
    );
  }
}
