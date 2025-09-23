import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../data/datasources/local/get_storage_ds.dart';
import '../../data/datasources/local/mock_data_provider.dart';
import '../../data/datasources/remote/firestore_ds.dart';
import '../../data/datasources/remote/storage_ds.dart';
import '../../data/repositories/auction_repo.dart';
import '../../data/repositories/deal_repo.dart';
import '../../data/repositories/pricing_repo.dart';
import '../../data/repositories/product_repo.dart';
import '../../data/repositories/wanted_repo.dart';
import '../../services/auth_service.dart';
import '../../services/auction_sync_service.dart';
import '../../services/gemini_service.dart';
import '../../services/location_service.dart';
import '../../services/notification_service.dart';
import '../../services/pricing_service.dart';

class GlobalBindings extends Bindings {
  @override
  void dependencies() {
    final storage = GetStorage();
    Get.put(GetStorageDataSource(storage), permanent: true);
    Get.put(const MockDataProvider(), permanent: true);

    Get.lazyPut(() => FirestoreDataSource(FirebaseFirestore.instance),
        fenix: true);
    Get.lazyPut(() => StorageDataSource(FirebaseStorage.instance), fenix: true);

    Get.put(AuthService(FirebaseAuth.instance), permanent: true);
    Get.put(LocationService(), permanent: true);

    Get.put(
      NotificationService(
        FirebaseMessaging.instance,
        Get.find<GetStorageDataSource>(),
        Get.find<AuthService>(),
      ),
      permanent: true,
    );

    Get.put(
      GeminiService(
        apiKeyProvider: () async {
          // TODO: Replace with Firebase Remote Config or secure storage.
          return Get.find<GetStorageDataSource>().read<String>('gemini_api_key');
        },
      ),
      permanent: true,
    );

    Get.put(
      PricingRepository(mockProvider: Get.find<MockDataProvider>()),
      permanent: true,
    );
    Get.put(
      PricingService(pricingRepository: Get.find<PricingRepository>()),
      permanent: true,
    );

    Get.put(
      ProductRepository(
        firestore: Get.find<FirestoreDataSource>(),
        mockProvider: Get.find<MockDataProvider>(),
      ),
      permanent: true,
    );

    Get.put(
      AuctionRepository(
        firestore: Get.find<FirestoreDataSource>(),
        mockProvider: Get.find<MockDataProvider>(),
      ),
      permanent: true,
    );

    Get.put(
      DealRepository(
        firestore: Get.find<FirestoreDataSource>(),
        mockProvider: Get.find<MockDataProvider>(),
      ),
      permanent: true,
    );

    Get.put(
      WantedRepository(
        firestore: Get.find<FirestoreDataSource>(),
        mockProvider: Get.find<MockDataProvider>(),
      ),
      permanent: true,
    );

    Get.put(
      AuctionSyncService(auctionRepository: Get.find<AuctionRepository>()),
      permanent: true,
    );
  }
}
