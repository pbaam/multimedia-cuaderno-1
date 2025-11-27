import '../models/user.dart';

class UserRepository {
  static final List<User> _users = [
    // Pre-registered admin user
    User(
      name: 'admin',
      password: 'admin',
      email: 'admin@admin.com',
      birthPlace: 'System',
      treatment: 'Sr',
      age: 30,
      role: UserRole.administrator,
    ),
  ];

  Future<bool> register(User user) async {
    if (_users.any((u) => u.name == user.name || u.email == user.email)) {
      return false;
    }
    _users.add(user);
    return true;
  }

  Future<User?> login(String name, String password) async {
    // Return null if no user matches (handles empty list gracefully)
    for (var user in _users) {
      if (user.name == name && user.password == password) {
        return user;
      }
    }
    return null;
  }

  List<User> getAllUsers() => List.unmodifiable(_users);
}
