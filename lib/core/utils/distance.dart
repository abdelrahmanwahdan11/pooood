import '../../data/repositories/settings_repo.dart';

class DistanceUtils {
  static String formatDistance(double kilometers, DistanceUnit unit) {
    if (unit == DistanceUnit.miles) {
      final miles = kilometers * 0.621371;
      return '${miles.toStringAsFixed(1)} mi';
    }
    return '${kilometers.toStringAsFixed(1)} km';
  }
}
