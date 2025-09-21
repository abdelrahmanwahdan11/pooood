import 'dart:async';

import 'package:flutter/material.dart';

class CountdownTimer extends StatefulWidget {
  const CountdownTimer({
    super.key,
    required this.endAt,
    this.onFinished,
    this.style,
    this.ticker,
  });

  final DateTime endAt;
  final VoidCallback? onFinished;
  final TextStyle? style;
  final Stream<DateTime>? ticker;

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late Duration _remaining;
  Timer? _timer;
  StreamSubscription<DateTime>? _tickerSub;
  DateTime _currentTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _remaining = _computeRemaining();
    _subscribe();
  }

  @override
  void didUpdateWidget(covariant CountdownTimer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.endAt != widget.endAt || oldWidget.ticker != widget.ticker) {
      _remaining = _computeRemaining();
      _subscribe();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _tickerSub?.cancel();
    super.dispose();
  }

  void _subscribe() {
    _timer?.cancel();
    _tickerSub?.cancel();
    if (widget.ticker != null) {
      _tickerSub = widget.ticker!.listen((current) {
        _currentTime = current;
        _update();
      });
    } else {
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        _currentTime = DateTime.now();
        _update();
      });
    }
  }

  void _update() {
    final newRemaining = _computeRemaining();
    if (!mounted) return;
    setState(() {
      _remaining = newRemaining;
    });
    if (newRemaining <= Duration.zero) {
      widget.onFinished?.call();
      _timer?.cancel();
      _tickerSub?.cancel();
    }
  }

  Duration _computeRemaining() {
    final difference = widget.endAt.difference(_currentTime);
    if (difference.isNegative) {
      return Duration.zero;
    }
    return difference;
  }

  String _formatDuration(Duration duration) {
    if (duration <= Duration.zero) {
      return '00:00:00';
    }
    final days = duration.inDays;
    final hours = duration.inHours.remainder(24);
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    final buffer = StringBuffer();
    if (days > 0) {
      buffer.write('${days.toString().padLeft(2, '0')}:');
    }
    buffer
      ..write(hours.toString().padLeft(2, '0'))
      ..write(':')
      ..write(minutes.toString().padLeft(2, '0'))
      ..write(':')
      ..write(seconds.toString().padLeft(2, '0'));
    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _formatDuration(_remaining),
      style: widget.style ?? Theme.of(context).textTheme.bodyLarge,
    );
  }
}
