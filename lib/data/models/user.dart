class UserModel {
  const UserModel({
    required this.id,
    required this.displayName,
    this.photoUrl,
    this.phone,
    this.locale,
    this.favorites = const [],
    this.createdAt,
  });

  final String id;
  final String displayName;
  final String? photoUrl;
  final String? phone;
  final String? locale;
  final List<String> favorites;
  final DateTime? createdAt;

  UserModel copyWith({
    String? displayName,
    String? photoUrl,
    List<String>? favorites,
    String? locale,
  }) {
    return UserModel(
      id: id,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      phone: phone,
      locale: locale ?? this.locale,
      favorites: favorites ?? this.favorites,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'displayName': displayName,
        'photoUrl': photoUrl,
        'phone': phone,
        'locale': locale,
        'favs': favorites,
        'createdAt': createdAt?.toIso8601String(),
      };

  factory UserModel.fromJson(String id, Map<String, dynamic> json) {
    return UserModel(
      id: id,
      displayName: json['displayName'] as String? ?? 'Guest',
      photoUrl: json['photoUrl'] as String?,
      phone: json['phone'] as String?,
      locale: json['locale'] as String?,
      favorites: (json['favs'] as List<dynamic>? ?? []).cast<String>(),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
    );
  }
}
