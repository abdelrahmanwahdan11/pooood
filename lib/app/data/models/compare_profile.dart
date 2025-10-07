import 'ocean_score.dart';

class CompareProfile {
  CompareProfile({
    required this.code,
    required this.scores,
    required this.displayName,
  });

  final String code;
  final OceanScore scores;
  final String displayName;
}
