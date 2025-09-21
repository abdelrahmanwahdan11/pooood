import 'package:intl/intl.dart';

String formatCurrency(double value, {String locale = 'en', String currency = 'USD'}) {
  final symbol = currency == 'USD' ? 'USD ' : '$currency ';
  return NumberFormat.currency(locale: locale, symbol: symbol).format(value);
}

String formatDistance(double kilometers, {String locale = 'en'}) {
  return NumberFormat('#0.0', locale).format(kilometers);
}
