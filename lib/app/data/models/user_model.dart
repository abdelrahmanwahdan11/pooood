/*
  هذا الملف يحتوي نموذج المستخدم مع دوال التحويل وحالة الضيف.
  يمكن إضافة خصائص جديدة مثل العنوان أو الصورة الشخصية بتوسيع الدوال.
*/
import 'dart:convert';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final bool isGuest;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.isGuest = false,
  });

  factory UserModel.guest()
      : this(id: 'guest', name: 'Guest', email: 'guest@local', phone: '', isGuest: true);

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      isGuest: json['is_guest'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
        'is_guest': isGuest,
      };

  static UserModel? fromJsonString(String? source) {
    if (source == null || source.isEmpty) return null;
    return UserModel.fromJson(jsonDecode(source) as Map<String, dynamic>);
  }

  static String? toJsonString(UserModel? user) {
    if (user == null) return null;
    return jsonEncode(user.toJson());
  }
}
