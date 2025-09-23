# Glass Liquid Auctions Setup Notes

1. **Flutter SDK**: Use Flutter 3.19+ (stable). Run `flutter pub get`.
2. **Firebase**:
   - Execute `flutterfire configure` to generate `firebase_options.dart` and link Firebase projects.
   - Enable Auth providers (Email/Password, Phone, Google, Apple), Firestore, Storage, Functions, and Cloud Messaging.
   - Deploy security rules and indexes from `firebase/firestore.rules` and `firebase/firestore.indexes.json`.
   - Deploy Cloud Functions from `firebase/functions` after adding environment secrets (Gemini API key, etc.).
3. **Gemini / Vertex AI for Firebase**:
   - Store the API key securely (Remote Config or `.env`) and write it into `GetStorageDataSource` (key: `gemini_api_key`).
   - For production, prefer calling Vertex AI via a callable Cloud Function to hide keys.
4. **TensorFlow Lite**:
   - Place your model at `assets/tflite/model.tflite`.
   - Update preprocessing logic in `PricingService._encode` to match your training pipeline.
5. **Google Maps**:
   - Provide API keys for Android, iOS, and Web as described in `google_maps_flutter` docs.
6. **Local testing**:
   - `flutter run -d chrome --web-renderer html`
   - `flutter run -d ios` / `flutter run -d android`
7. **Web build**:
   - `flutter build web --web-renderer html --release`
8. **Mock Data**: The app loads mock data from `assets/mock/*.json` until Firebase connectivity is ready.
