/*
  هذا الملف يوفّر منطق المصادقة المبسط مع دعم المستخدم الضيف وتخزين الجلسة.
  يمكن توسيعه لإضافة تكاملات خارجية أو إدارة أدوار متعددة.
*/
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../core/utils/validators.dart';
import '../models/user_model.dart';
import 'storage_service.dart';

class AuthService extends GetxService {
  static AuthService get to => Get.find<AuthService>();

  final _uuid = const Uuid();

  Future<UserModel> login({required String email, required String password}) async {
    final emailError = Validators.validateEmail(email);
    final passwordError = Validators.validatePassword(password);
    if (emailError != null) {
      throw emailError;
    }
    if (passwordError != null) {
      throw passwordError;
    }
    final existing = StorageService.to.getUser();
    if (existing != null && existing.email == email && !existing.isGuest) {
      await StorageService.to.saveUser(existing);
      return existing;
    }
    final user = UserModel(
      id: _uuid.v4(),
      name: email.split('@').first,
      email: email,
      phone: '',
    );
    await StorageService.to.saveUser(user);
    return user;
  }

  Future<UserModel> signup({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    final nameError = Validators.validateNonEmpty(name);
    final emailError = Validators.validateEmail(email);
    final phoneError = Validators.validatePhone(phone);
    final passwordError = Validators.validatePassword(password);
    if (nameError != null) throw nameError;
    if (emailError != null) throw emailError;
    if (phoneError != null) throw phoneError;
    if (passwordError != null) throw passwordError;
    final user = UserModel(
      id: _uuid.v4(),
      name: name,
      email: email,
      phone: phone,
    );
    await StorageService.to.saveUser(user);
    return user;
  }

  Future<UserModel> guestLogin() async {
    final guest = UserModel.guest();
    await StorageService.to.saveUser(guest);
    return guest;
  }

  Future<void> logout() async {
    await StorageService.to.saveUser(null);
  }
}
