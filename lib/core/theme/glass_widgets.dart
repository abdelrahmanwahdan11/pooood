import 'dart:ui';

import 'package:flutter/material.dart';

import 'colors.dart';

class GradientGlassCard extends StatelessWidget {
  const GradientGlassCard({
    super.key,
    this.onTap,
    this.margin,
    this.padding,
    required this.child,
  });

  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final card = Container(
      margin: margin ?? const EdgeInsets.symmetric(vertical: 8),
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppColors.glassGradient(),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
        boxShadow: const [
          BoxShadow(
            color: AppColors.glassShadow,
            blurRadius: 24,
            offset: Offset(0, 16),
          ),
        ],
      ),
      child: child,
    );
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: onTap != null
            ? InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(24),
                child: card,
              )
            : card,
      ),
    );
  }
}

class GlassScaffold extends StatelessWidget {
  const GlassScaffold({
    super.key,
    this.background,
    this.floatingActionButton,
    this.bottomNavigationBar,
    required this.body,
    this.drawer,
    this.endDrawer,
    this.appBar,
  });

  final Widget body;
  final Widget? background;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final Widget? drawer;
  final Widget? endDrawer;
  final PreferredSizeWidget? appBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: appBar,
      drawer: drawer,
      endDrawer: endDrawer,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      body: Stack(
        fit: StackFit.expand,
        children: [
          background ?? const _LiquidBackground(),
          SafeArea(child: body),
        ],
      ),
    );
  }
}

class GlassAppBar extends StatelessWidget implements PreferredSizeWidget {
  const GlassAppBar({
    super.key,
    this.title,
    this.actions,
    this.leading,
  });

  final Widget? title;
  final List<Widget>? actions;
  final Widget? leading;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 6);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: AppBar(
          elevation: 0,
          backgroundColor: Colors.black.withOpacity(0.2),
          title: title,
          leading: leading,
          actions: actions,
        ),
      ),
    );
  }
}

class _LiquidBackground extends StatefulWidget {
  const _LiquidBackground();

  @override
  State<_LiquidBackground> createState() => _LiquidBackgroundState();
}

class _LiquidBackgroundState extends State<_LiquidBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(reverse: true);
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
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primary.withOpacity(0.8),
                AppColors.primary.withOpacity(0.4 + 0.2 * _controller.value),
                AppColors.accent.withOpacity(0.3),
              ],
            ),
          ),
          child: CustomPaint(
            painter: _LiquidPainter(progress: _controller.value),
          ),
        );
      },
    );
  }
}

class _LiquidPainter extends CustomPainter {
  _LiquidPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.white.withOpacity(0.08)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 16);

    final width = size.width;
    final height = size.height;

    final offset = progress * width / 3;
    final path = Path()
      ..moveTo(-width, height * 0.3)
      ..quadraticBezierTo(
        width * 0.25 + offset,
        height * 0.15,
        width * 0.5 + offset,
        height * 0.35,
      )
      ..quadraticBezierTo(
        width * 0.75 + offset,
        height * 0.55,
        width * 1.2 + offset,
        height * 0.4,
      )
      ..lineTo(width * 1.2 + offset, height + 100)
      ..lineTo(-width, height + 100)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _LiquidPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
