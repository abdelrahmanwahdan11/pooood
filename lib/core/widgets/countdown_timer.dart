import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CountdownTimer extends StatefulWidget {
  const CountdownTimer({
    super.key,
    required this.endTime,
  });

  final DateTime endTime;

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late Duration remaining;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    remaining = widget.endTime.difference(DateTime.now());
    timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _tick() {
    final diff = widget.endTime.difference(DateTime.now());
    if (!mounted) return;
    setState(() {
      remaining = diff.isNegative ? Duration.zero : diff;
    });
    if (diff.isNegative) {
      timer?.cancel();
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hours = remaining.inHours;
    final minutes = remaining.inMinutes % 60;
    final seconds = remaining.inSeconds % 60;
    final isEnded = remaining == Duration.zero;
    return Chip(
      label: Text(
        isEnded
            ? 'auction_ended'.tr
            : '${hours.toString().padLeft(2, '0')}:'
                '${minutes.toString().padLeft(2, '0')}:'
                '${seconds.toString().padLeft(2, '0')}',
      ),
      avatar: Icon(
        isEnded ? Icons.check_circle : Icons.timer,
        color: isEnded ? Colors.greenAccent : Colors.white,
      ),
      backgroundColor: Colors.black.withOpacity(0.3),
    );
  }
}
