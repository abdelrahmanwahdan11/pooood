class PriceWatch {
  const PriceWatch({
    required this.id,
    required this.title,
    required this.category,
    required this.desiredPrice,
    required this.acceptableRange,
    required this.notes,
    required this.preferredAreas,
    required this.expiryDate,
    required this.contactPreference,
    required this.receiveAlerts,
    required this.matches,
  });

  final int id;
  final String title;
  final String category;
  final double desiredPrice;
  final double acceptableRange;
  final String notes;
  final String preferredAreas;
  final DateTime expiryDate;
  final String contactPreference;
  final bool receiveAlerts;
  final int matches;

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'category': category,
        'desiredPrice': desiredPrice,
        'acceptableRange': acceptableRange,
        'notes': notes,
        'preferredAreas': preferredAreas,
        'expiryDate': expiryDate.millisecondsSinceEpoch,
        'contactPreference': contactPreference,
        'receiveAlerts': receiveAlerts ? 1 : 0,
        'matches': matches,
      };

  static PriceWatch fromMap(Map<String, dynamic> map) => PriceWatch(
        id: map['id'] as int,
        title: map['title'] as String,
        category: map['category'] as String,
        desiredPrice: (map['desiredPrice'] as num).toDouble(),
        acceptableRange: (map['acceptableRange'] as num).toDouble(),
        notes: map['notes'] as String,
        preferredAreas: map['preferredAreas'] as String,
        expiryDate:
            DateTime.fromMillisecondsSinceEpoch(map['expiryDate'] as int),
        contactPreference: map['contactPreference'] as String,
        receiveAlerts: (map['receiveAlerts'] as int) == 1,
        matches: map['matches'] as int,
      );
}
