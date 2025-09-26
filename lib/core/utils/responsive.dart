import 'package:flutter/material.dart';

class Responsive {
  static bool isCompact(BuildContext context) =>
      MediaQuery.of(context).size.width < 360;

  static bool isMedium(BuildContext context) =>
      MediaQuery.of(context).size.width >= 360 &&
      MediaQuery.of(context).size.width < 600;

  static bool isExpanded(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600;

  static double adaptivePadding(BuildContext context) {
    if (isExpanded(context)) return 32;
    if (isMedium(context)) return 24;
    return 16;
  }

  static double adaptiveTextScale(BuildContext context) {
    if (isExpanded(context)) return 1.05;
    if (isCompact(context)) return 0.95;
    return 1.0;
  }
}
