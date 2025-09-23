import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

import '../data/datasources/local/get_storage_ds.dart';
import 'auth_service.dart';

class NotificationService extends GetxService {
  NotificationService(this._messaging, this._storage, this._authService);

  final FirebaseMessaging _messaging;
  final GetStorageDataSource _storage;
  final AuthService _authService;

  Future<void> init() async {
    final settings = await _messaging.requestPermission();
    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      Get.log('Notifications denied by user');
      return;
    }
    final token = await _messaging.getToken();
    if (token != null) {
      await _storage.write('fcm_token', token);
      // TODO: Save token to users/{uid} document for direct messaging.
    }
    FirebaseMessaging.onMessage.listen((event) {
      Get.snackbar(event.notification?.title ?? 'Notification',
          event.notification?.body ?? '');
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      Get.log('Notification opened: ${message.data}');
    });
  }

  Future<void> subscribeToAuction(String auctionId) {
    return _messaging.subscribeToTopic('auction_$auctionId');
  }

  Future<void> unsubscribeFromAuction(String auctionId) {
    return _messaging.unsubscribeFromTopic('auction_$auctionId');
  }

  Future<void> subscribeToCityDeals(String city) {
    return _messaging.subscribeToTopic('deals_city_${city.toLowerCase()}');
  }

  Future<void> registerUserTopics() async {
    final user = _authService.firebaseUser.value;
    if (user == null) return;
    await _messaging.subscribeToTopic('wanted_${user.uid}');
  }
}
