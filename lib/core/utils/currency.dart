import 'package:intl/intl.dart';

class CurrencyFormatter {
  const CurrencyFormatter._();

  static final NumberFormat _format = NumberFormat.currency(symbol: 'SAR ');

  static String format(double value) => _format.format(value);
}
