import '../models/pricing_request.dart';

abstract class PricingRepository {
  PricingRequest submitEstimate({
    required String productName,
    required String condition,
    required double basePrice,
  });
}

class InMemoryPricingRepository implements PricingRepository {
  // Firebase integration placeholder:
  // Swap to a callable Cloud Function or Firestore document write
  // when the backend is ready.
  //
  // import 'package:cloud_functions/cloud_functions.dart';
  //
  // class CloudPricingRepository implements PricingRepository {
  //   CloudPricingRepository(this._functions);
  //
  //   final FirebaseFunctions _functions;
  //
  //   @override
  //   Future<PricingRequest> submitEstimate({
  //     required String productName,
  //     required String condition,
  //     required double basePrice,
  //   }) async {
  //     final result = await _functions.httpsCallable('estimatePrice').call({
  //       'productName': productName,
  //       'condition': condition,
  //       'basePrice': basePrice,
  //     });
  //     final data = Map<String, dynamic>.from(result.data as Map);
  //     return PricingRequest.fromMap(data);
  //   }
  // }

  @override
  PricingRequest submitEstimate({
    required String productName,
    required String condition,
    required double basePrice,
  }) {
    final adjustment = condition.toLowerCase().contains('جديد') ? 1.12 : 0.84;
    final estimated = basePrice * adjustment;
    return PricingRequest(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      productName: productName,
      condition: condition,
      estimatedPrice: estimated,
      recommendedTime: 'مساء الخميس',
      recommendedArea: 'واجهة الرياض',
    );
  }
}
