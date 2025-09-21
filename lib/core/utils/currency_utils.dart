import 'package:intl/intl.dart';

class CurrencyUtils {
  CurrencyUtils._();

  static String format(double value, {String currency = 'USD', String? locale}) {
    final format = NumberFormat.currency(
      locale: locale ?? Intl.getCurrentLocale(),
      name: currency,
      symbol: NumberFormat.simpleCurrency(name: currency).currencySymbol,
    );
    return format.format(value);
  }

  static String formatRange(
    double min,
    double max, {
    String currency = 'USD',
    String? locale,
  }) {
    final lower = format(min, currency: currency, locale: locale);
    final upper = format(max, currency: currency, locale: locale);
    return '$lower - $upper';
  }
}
