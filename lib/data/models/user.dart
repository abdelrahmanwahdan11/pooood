class User {
  const User({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.phone,
    required this.email,
    required this.defaultLocation,
    required this.paymentMethod,
  });

  final int id;
  final String name;
  final String avatarUrl;
  final String phone;
  final String email;
  final String defaultLocation;
  final String paymentMethod;

  User copyWith({
    String? name,
    String? avatarUrl,
    String? phone,
    String? email,
    String? defaultLocation,
    String? paymentMethod,
  }) {
    return User(
      id: id,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      defaultLocation: defaultLocation ?? this.defaultLocation,
      paymentMethod: paymentMethod ?? this.paymentMethod,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'avatarUrl': avatarUrl,
        'phone': phone,
        'email': email,
        'defaultLocation': defaultLocation,
        'paymentMethod': paymentMethod,
      };

  static User fromMap(Map<String, dynamic> map) => User(
        id: map['id'] as int,
        name: map['name'] as String,
        avatarUrl: map['avatarUrl'] as String,
        phone: map['phone'] as String,
        email: map['email'] as String,
        defaultLocation: map['defaultLocation'] as String,
        paymentMethod: map['paymentMethod'] as String,
      );
}
