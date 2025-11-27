enum UserRole {
  ordinary,
  administrator,
}

class User {
  String name;
  String password;
  String email;
  String? imagePath;
  String birthPlace;
  String treatment;
  int age;
  UserRole role;

  User({
    required this.name,
    required this.password,
    required this.email,
    this.imagePath,
    required this.birthPlace,
    required this.treatment,
    required this.age,
    this.role = UserRole.ordinary,
  });
}