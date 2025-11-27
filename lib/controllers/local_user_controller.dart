import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/user_repository.dart';
import '../models/user.dart';

class LocalUserController extends ChangeNotifier {
  final UserRepository _repository = UserRepository();
  User? currentUser;
  bool _initialized = false;

  Future<void> initializeSession() async {
    if (_initialized) return;

    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('logged_user');

    if (username != null) {
      final users = _repository.getAllUsers();
      try {
        currentUser = users.firstWhere((u) => u.name == username);
      } catch (e) {
        await prefs.remove('logged_user');
      }
    }

    _initialized = true;
    notifyListeners();
  }

  Future<bool> login(String name, String password) async {
    final user = await _repository.login(name, password);
    if (user != null) {
      currentUser = user;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('logged_user', user.name);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> register(User user) async {
    final success = await _repository.register(user);
    if (success) {
      notifyListeners();
    }
    return success;
  }

  Future<void> logout() async {
    currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('logged_user');
    notifyListeners();
  }

  User? get user => currentUser;
  bool get isLoggedIn => currentUser != null;
}
