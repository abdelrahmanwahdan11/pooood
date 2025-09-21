import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/glass_theme.dart';

class GlassContainer extends StatelessWidget {
  const GlassContainer({
    super.key,
    this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin = EdgeInsets.zero,
    this.alignment,
    this.style = const GlassContainerStyle(),
  });

  final Widget? child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final AlignmentGeometry? alignment;
  final GlassContainerStyle style;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: ClipRRect(
        borderRadius: style.borderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: style.blur, sigmaY: style.blur),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              gradient: style.gradient,
              borderRadius: style.borderRadius,
              border: style.border,
            ),
            padding: padding,
            alignment: alignment,
            child: child,
          ),
        ),
      ),
    );
  }
}
