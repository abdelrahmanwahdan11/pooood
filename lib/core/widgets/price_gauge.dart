import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../theme/colors.dart';

class PriceGauge extends StatelessWidget {
  const PriceGauge({
    super.key,
    required this.value,
    required this.min,
    required this.max,
    required this.confidence,
  });

  final double value;
  final double min;
  final double max;
  final double confidence;

  @override
  Widget build(BuildContext context) {
    final normalized = ((value - min) / (max - min)).clamp(0.0, 1.0);
    final confidenceLabel = (confidence * 100).toStringAsFixed(0);
    return SizedBox(
      height: 180,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            painter: _GaugePainter(value: normalized),
            size: const Size(180, 180),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'confidence_label'.trParams({'value': confidenceLabel}),
                style: Get.textTheme.labelMedium,
              ),
              const SizedBox(height: 8),
              Text(
                value.toStringAsFixed(0),
                style: Get.textTheme.displaySmall?.copyWith(
                  color: AppColors.accent,
                ),
              ),
              Text(
                'price_range'.trParams({
                  'min': min.toStringAsFixed(0),
                  'max': max.toStringAsFixed(0),
                }),
                style: Get.textTheme.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GaugePainter extends CustomPainter {
  _GaugePainter({required this.value});

  final double value;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final startAngle = math.pi;
    final sweepAngle = math.pi;
    final backgroundPaint = Paint()
      ..color = Colors.white.withOpacity(0.08)
      ..strokeWidth = 18
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final progressPaint = Paint()
      ..shader = LinearGradient(colors: AppColors.neonAccent).createShader(rect)
      ..strokeWidth = 18
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: rect.center, radius: size.width / 2.2),
      startAngle,
      sweepAngle,
      false,
      backgroundPaint,
    );
    canvas.drawArc(
      Rect.fromCircle(center: rect.center, radius: size.width / 2.2),
      startAngle,
      sweepAngle * value,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _GaugePainter oldDelegate) => value != oldDelegate.value;
}
