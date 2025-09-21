import 'dart:async';

import 'package:flutter/material.dart';

class CountdownTimer extends StatefulWidget {
  const CountdownTimer({
    super.key,
    required this.endAt,
    this.textStyle,
  });

  final DateTime endAt;
  final TextStyle? textStyle;

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late Stream<int> _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = Stream.periodic(const Duration(seconds: 1), (x) => x);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: _ticker,
      builder: (context, snapshot) {
        final remaining = widget.endAt.difference(DateTime.now());
        final totalSeconds = remaining.inSeconds;
        if (totalSeconds <= 0) {
          return Text('00:00:00', style: widget.textStyle);
        }
        final hours = remaining.inHours.remainder(100).toString().padLeft(2, '0');
        final minutes = remaining.inMinutes.remainder(60).toString().padLeft(2, '0');
        final seconds = remaining.inSeconds.remainder(60).toString().padLeft(2, '0');
        return Text('$hours:$minutes:$seconds', style: widget.textStyle);
      },
    );
  }
}
