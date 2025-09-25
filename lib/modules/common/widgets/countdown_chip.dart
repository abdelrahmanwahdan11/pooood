import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CountdownChip extends StatelessWidget {
  const CountdownChip({super.key, required this.duration});

  final Duration duration;

  @override
  Widget build(BuildContext context) {
    final formatted = _format(duration);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.black.withOpacity(0.45),
      ),
      child: Text(
        formatted,
        style: Theme.of(context)
            .textTheme
            .labelLarge
            ?.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
      ),
    );
  }

  String _format(Duration duration) {
    if (duration.inSeconds <= 0) return '00:00:00';
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    final hoursStr = NumberFormat('00').format(hours);
    final minutesStr = NumberFormat('00').format(minutes);
    final secondsStr = NumberFormat('00').format(seconds);
    return '$hoursStr:$minutesStr:$secondsStr';
  }
}
