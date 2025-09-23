import 'package:intl/intl.dart';

class TimeUtils {
  const TimeUtils._();

  static String relative(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inMinutes.abs() < 1) {
      return 'just_now';
    }
    if (diff.isNegative) {
      if (diff.inHours.abs() < 1) {
        return 'in_minutes:${diff.inMinutes.abs()}';
      }
      return 'in_hours:${diff.inHours.abs()}';
    }
    if (diff.inHours < 1) {
      return 'minutes_ago:${diff.inMinutes}';
    }
    if (diff.inDays < 1) {
      return 'hours_ago:${diff.inHours}';
    }
    return DateFormat.yMMMd().format(date);
  }
}
