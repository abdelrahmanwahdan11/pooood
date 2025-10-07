import 'package:flutter/material.dart';

class LayoutHelper {
  LayoutHelper._();

  static Widget constrain({required Widget child}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        if (maxWidth > 840) {
          return Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 840),
              child: child,
            ),
          );
        }
        return child;
      },
    );
  }
}
