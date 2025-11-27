import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/user_repository.dart';
import '../services/firebase_auth_service.dart';
import '../models/user.dart';

class LocalUserController extends ChangeNotifier {
  final UserRepository _repository = UserRepository();
  FirebaseAuthService? _firebaseAuthService;
  User? currentUser;
  bool _initialized = false;

  // Initialize Firebase Auth Service lazily
  Future<void> _ensureFirebaseInitialized() async {
    if (_firebaseAuthService == null) {
      _firebaseAuthService = FirebaseAuthService();
    }
  }

  Future<void> initializeSession() async {
    if (_initialized) return;

    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('logged_user');
    final isGoogleUser = prefs.getBool('is_google_user') ?? false;

    if (username != null) {
      if (isGoogleUser && false) {
        // Check if still signed in with Google
        await _ensureFirebaseInitialized();
        if (_firebaseAuthService?.isSignedInWithGoogle() ?? false) {
          final users = _repository.getAllUsers();
          try {
            currentUser = users.firstWhere((u) => u.name == username);
          } catch (e) {
            await prefs.remove('logged_user');
            await prefs.remove('is_google_user');
          }
        } else {
          await prefs.remove('logged_user');
          await prefs.remove('is_google_user');
        }
      } else {
        // Regular user
        final users = _repository.getAllUsers();
        try {
          currentUser = users.firstWhere((u) => u.name == username);
        } catch (e) {
          await prefs.remove('logged_user');
        }
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
      await prefs.setBool('is_google_user', false);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> loginWithGoogle() async {
    await _ensureFirebaseInitialized();
    final user = await _firebaseAuthService?.signInWithGoogle();
    
    if (user == null) {
      return false;
    }

    // Check if user already exists in repository
    final existingUsers = _repository.getAllUsers();
    final existingUser = existingUsers.where((u) => u.email == user.email).firstOrNull;

    if (existingUser != null) {
      // User exists, log them in
      currentUser = existingUser;
    } else {
      // New Google user, register them
      final success = await _repository.register(user);
      if (!success) {
        return false;
      }
      currentUser = user;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('logged_user', currentUser!.name);
    await prefs.setBool('is_google_user', true);
    notifyListeners();
    return true;
  }

  Future<bool> register(User user) async {
    final success = await _repository.register(user);
    if (success) {
      notifyListeners();
    }
    return success;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    final isGoogleUser = prefs.getBool('is_google_user') ?? false;
    
    if (isGoogleUser) {
      await _ensureFirebaseInitialized();
      await _firebaseAuthService?.signOut();
    }
    
    currentUser = null;
    await prefs.remove('logged_user');
    await prefs.remove('is_google_user');
    notifyListeners();
  }

  User? get user => currentUser;
  bool get isLoggedIn => currentUser != null;
}
