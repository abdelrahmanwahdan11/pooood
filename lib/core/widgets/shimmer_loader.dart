import 'package:flutter/material.dart';

import '../theme/green_theme.dart';

class ShimmerLoader extends StatefulWidget {
  const ShimmerLoader({
    super.key,
    this.width,
    this.height = 120,
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
  });

  final double? width;
  final double height;
  final BorderRadius borderRadius;

  @override
  State<ShimmerLoader> createState() => _ShimmerLoaderState();
}

class _ShimmerLoaderState extends State<ShimmerLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final shimmerPosition = _controller.value * 2 - 1;
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius,
            gradient: LinearGradient(
              colors: [
                GreenPalette.primary.withOpacity(0.15),
                Colors.white.withOpacity(0.35),
                GreenPalette.secondary.withOpacity(0.2),
              ],
              stops: const [0.1, 0.5, 0.9],
              begin: Alignment(-1, -0.3),
              end: Alignment(1, 0.3),
              transform: GradientRotation(shimmerPosition * 0.5),
            ),
          ),
        );
      },
    );
  }
}
