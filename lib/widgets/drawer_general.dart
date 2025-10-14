import 'package:flutter/material.dart';

class DrawerGeneral extends StatelessWidget {
  const DrawerGeneral({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.lightBlueAccent),
              child: Text('Menú'),
            ),
            ListTile(
              title: Text('Pantalla Principal'),
              selected: ModalRoute.of(context)?.settings.name == '/main',
              onTap: () => Navigator.pushReplacementNamed(context, '/main'),
            ),
            ListTile(
              title: Text('Mi Perfil'),
              selected: ModalRoute.of(context)?.settings.name == '/profile',
              onTap: () => Navigator.pushReplacementNamed(context, '/profile'),
            ),
            ListTile(
              title: Text('Salir'),
              selected: ModalRoute.of(context)?.settings.name == '/login',
              onTap: () => Navigator.pushReplacementNamed(context, '/login'),
            ),
          ],
        ),
      );
  }
}