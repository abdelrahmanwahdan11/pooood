import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class GlassContainer extends StatefulWidget {
  const GlassContainer({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.margin,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;

  @override
  State<GlassContainer> createState() => _GlassContainerState();
}

class _GlassContainerState extends State<GlassContainer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0,
      upperBound: 1,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(_) => _controller.forward();

  void _handleTapUp(_) => _controller.reverse();

  @override
  Widget build(BuildContext context) {
    final container = AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = _controller.value;
        return Transform.scale(
          scale: 1 - (t * 0.02),
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withOpacity(0.25)),
              color: Colors.white.withOpacity(0.28 + (t * 0.07)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.12 + (t * 0.1)),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: child,
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18 + (_controller.value * 4), sigmaY: 18 + (_controller.value * 4)),
          child: Padding(
            padding: widget.padding ?? const EdgeInsets.all(20),
            child: widget.child,
          ),
        ),
      ),
    );

    final interactive = widget.onTap == null
        ? container
        : GestureDetector(
            onTap: widget.onTap,
            onTapDown: _handleTapDown,
            onTapCancel: _handleTapUp,
            onTapUp: _handleTapUp,
            child: container,
          );

    return Container(
      margin: widget.margin,
      child: interactive
          .animate()
          .fadeIn(duration: const Duration(milliseconds: 250), curve: Curves.easeOutCubic)
          .slideY(begin: 0.08, end: 0, duration: const Duration(milliseconds: 250)),
    );
  }
}
