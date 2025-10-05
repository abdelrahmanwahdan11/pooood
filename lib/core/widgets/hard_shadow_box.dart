import 'package:flutter/material.dart';

class HardShadowBox extends StatelessWidget {
  const HardShadowBox({
    super.key,
    required this.child,
    this.backgroundColor = Colors.white,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = 18,
    this.shadowOffset = const Offset(6, 6),
    this.height,
    this.width,
  });

  final Widget child;
  final Color backgroundColor;
  final EdgeInsets padding;
  final double borderRadius;
  final Offset shadowOffset;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: Stack(
        children: [
          Positioned(
            left: shadowOffset.dx,
            top: shadowOffset.dy,
            right: -shadowOffset.dx,
            bottom: -shadowOffset.dy,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(borderRadius),
              ),
            ),
          ),
          Container(
            padding: padding,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(color: Colors.black, width: 3),
            ),
            child: child,
          ),
        ],
      ),
    );
  }
}
