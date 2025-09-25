import '../models/user.dart';

abstract class UserRepository {
  User get currentUser;
}

class InMemoryUserRepository implements UserRepository {
  InMemoryUserRepository();

  @override
  User get currentUser => User.demo;
}
