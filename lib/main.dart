import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/local_user_controller.dart';
import 'screens/pantalla_principal.dart';
import 'screens/pantalla_perfil.dart';
import 'screens/pantalla_registro.dart';
import 'screens/pantalla_inicio_sesion.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) {
        LocalUserController();
      },
      child: App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cuaderno 1 - Aplicaciones Multiplataforma',
      // home: PantallaInicioSesion(),
      initialRoute: '/login',
      routes: {
        '/login': (context) => PantallaInicioSesion(),
        '/main': (context) => PantallaPrincipal(),
        '/profile': (context) => PantallaPerfil(),
        '/register': (context) => PantallaRegistro(),
      }
    );
  }
}