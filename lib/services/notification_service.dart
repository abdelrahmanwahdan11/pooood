import '../data/datasources/local/get_storage_ds.dart';
import '../data/models/user_alert.dart';

class NotificationService {
  NotificationService({required this.localDataSource});

  final GetStorageDataSource localDataSource;

  List<UserAlert> getAlerts() => localDataSource.alerts;

  void upsertAlert(UserAlert alert) {
    final alerts = getAlerts();
    final index = alerts.indexWhere((a) => a.id == alert.id);
    if (index >= 0) {
      alerts[index] = alert;
    } else {
      alerts.add(alert);
    }
    localDataSource.saveAlerts(alerts);
  }

  void removeAlert(String id) {
    final alerts = getAlerts();
    alerts.removeWhere((element) => element.id == id);
    localDataSource.saveAlerts(alerts);
  }

  // TODO: Firebase
  // 1) إضافة حزم firebase_core, firebase_messaging, cloud_firestore إلى pubspec.
  // 2) إنشاء firebase_options.dart عبر `flutterfire configure` وتحديث main.dart للتهيئة.
  // 3) حفظ تنبيهات السعر داخل مجموعة Firestore مثل `users/{uid}/alerts/{alertId}`.
  // 4) ضبط قواعد الأمان للسماح بالوصول المقيد للمستخدم المسجّل فقط.
  // 5) إنشاء Cloud Function مجدولة تتحقق من الأسعار وتستدعي Firebase Cloud Messaging عندما price <= targetPrice.
}
