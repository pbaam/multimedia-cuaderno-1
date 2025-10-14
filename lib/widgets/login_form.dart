import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/local_user_controller.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _StatefulWidget();
}

class _StatefulWidget extends State<LoginForm> {
  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          nameField(),
          passwordField(),
          loginButton(),
          registerButton(),
        ],
      ),
    );
  }

  Widget nameField() {
    return TextFormField(
      decoration: InputDecoration(hintText: 'Nombre'),
      validator: (value) {
        String name = (value ?? '');
        if (name.isEmpty) {
          return 'Debes introducir un nombre';
        }
        nameController.text = name;
        return null;
      },
    );
  }

  Widget passwordField() {
    return TextFormField(
      decoration: InputDecoration(hintText: 'contraseña'),
      validator: (value) {
        String password = (value ?? '');
        if (password.isEmpty) {
          return 'Debes introducir una contraseña';
        }
        passwordController.text = password;
        return null;
      },
    );
  }

  Widget loginButton() {
    return TextButton(
      child: Align(alignment: Alignment.center, child: Text('Iniciar Sesión')),
      onPressed: () async {
        final userController = Provider.of<LocalUserController>(context, listen: false);
        final login = await userController.login(
          nameController.text,
          passwordController.text,
        );
        if (!mounted) return;

        if (formKey.currentState!.validate() && login) {
          Navigator.pushReplacementNamed(context, '/main');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Contraseña o usuario incorrectos')),
          );
        }
      },
    );
  }

  Widget registerButton() {
    return TextButton(
      child: Align(alignment: Alignment.center, child: Text('Registrarse')),
      onPressed: () => Navigator.pushReplacementNamed(context, '/register'),
    );
  }
}
