import 'package:intl/intl.dart';

class Formatters {
  const Formatters._();

  static final _currency = NumberFormat.currency(symbol: '﷼');

  static String currency(double value) => _currency.format(value);

  static String compactDistance(double distanceKm) {
    if (distanceKm < 1) {
      return '${(distanceKm * 1000).toStringAsFixed(0)} م';
    }
    return '${distanceKm.toStringAsFixed(1)} كم';
  }
}
