import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:get/get.dart';

import '../data/models/product.dart';

class GeminiService extends GetxService {
  GeminiService({required this.apiKeyProvider});

  final Future<String?> Function() apiKeyProvider;
  GenerativeModel? _model;

  Future<void> _ensureModel() async {
    if (_model != null) return;
    final key = await apiKeyProvider();
    if (key == null || key.isEmpty) {
      Get.log('Gemini API key not configured. Add to Remote Config or env.');
      return;
    }
    _model = GenerativeModel(model: 'gemini-pro', apiKey: key);
  }

  Future<String?> summaryForProduct(Product product) async {
    await _ensureModel();
    if (_model == null) return null;
    final prompt = '''You are an expert marketplace assistant.
Summarize the product below in Arabic and English bullet lists. Highlight benefits, potential issues, and checklist items.
Product:
Title: ${product.title}
Brand: ${product.brand}
Category: ${product.category}
Description: ${product.description}
Base price: ${product.basePrice}
''';
    try {
      final response = await _model!.generateContent([Content.text(prompt)]);
      return response.text;
    } on Exception catch (e) {
      Get.log('Gemini request failed: $e');
      return null;
    }
  }
}
