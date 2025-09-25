import 'package:flutter/material.dart';

enum ScreenSize { compact, medium, expanded }

class Responsive {
  const Responsive._();

  static ScreenSize sizeOf(BoxConstraints constraints) {
    final width = constraints.maxWidth;
    if (width < 360) {
      return ScreenSize.compact;
    } else if (width < 600) {
      return ScreenSize.medium;
    }
    return ScreenSize.expanded;
  }

  static double horizontalPadding(ScreenSize size) {
    switch (size) {
      case ScreenSize.compact:
        return 12;
      case ScreenSize.medium:
        return 16;
      case ScreenSize.expanded:
        return 24;
    }
  }
}
