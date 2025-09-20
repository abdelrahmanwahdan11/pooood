import 'package:intl/intl.dart';

String formatCurrency(num value, {String locale = 'en_US', String symbol = '\$'}) {
  final formatter = NumberFormat.currency(locale: locale, symbol: symbol, decimalDigits: 2);
  return formatter.format(value);
}

String formatCompactNumber(num value, {String locale = 'en_US'}) {
  final formatter = NumberFormat.compact(locale: locale);
  return formatter.format(value);
}

String formatCountdown(Duration duration) {
  final hours = duration.inHours.remainder(24).toString().padLeft(2, '0');
  final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
  final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
  final days = duration.inDays;
  if (days > 0) {
    return '${days}d $hours:$minutes:$seconds';
  }
  return '$hours:$minutes:$seconds';
}

String formatDistance(double kilometers, {String locale = 'en_US'}) {
  final number = NumberFormat('#,##0.0', locale).format(kilometers);
  return '$number km';
}
