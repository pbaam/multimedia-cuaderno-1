import '../models/user.dart';

abstract class UserRepository {
  Future<bool> register(User user);
  Future<User?> login(String name, String password);
}

class LocalUserRepository implements UserRepository {
  final Map<String, User> _users = {};

  @override
  Future<bool> register(User user) async {
    if (_users.containsKey(user.name)) return false;
    _users[user.name] = user;
    return true;
  }

  @override
  Future<User?> login(String name, String password) async {
    final user = _users[name];
    if (user == null) return null;
    return user.password == password ? user : null;
  }
}