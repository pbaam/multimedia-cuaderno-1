import 'package:cuaderno1/services/logica_usuarios.dart';
import '../models/user.dart';

class LocalUserController {
  final LocalUserRepository _service = LocalUserRepository();
  User? currentUser;

  Future<bool> login(String email, String password) async {
    final user = await _service.login(email, password);
    if (user != null) {
      currentUser = user;
      return true;
    }
    return false;
  }

  Future<bool> register(
    String name,
    String password,
    String email,
    String imagePath,
    String birthPlace,
    String treatment,
    int age,
  ) async {
    User user = User(
      name,
      password,
      email,
      imagePath,
      birthPlace,
      treatment,
      age,
    );
    return _service.register(user);
  }

  void logout() {
    currentUser = null;
  }

  User? get user => currentUser;
}
