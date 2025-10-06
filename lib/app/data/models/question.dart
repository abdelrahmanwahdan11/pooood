import 'trait.dart';

class Question {
  Question({
    required this.id,
    required this.trait,
    required this.text,
    this.reverseScored = false,
  });

  final String id;
  final Trait trait;
  final Map<String, String> text;
  final bool reverseScored;

  String localized(String code) => text[code] ?? text['en'] ?? '';
}
