import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../controllers/local_user_controller.dart';
import '../services/audio_service.dart';

class DrawerGeneral extends StatelessWidget {
  final Function(int)? onNavigate;
  
  const DrawerGeneral({super.key, this.onNavigate});

  @override
  Widget build(BuildContext context) {
    final currentRoute = GoRouterState.of(context).matchedLocation;
    final userController = Provider.of<LocalUserController>(context, listen: false);
    final audioService = Provider.of<AudioService>(context, listen: false);
    
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.lightBlueAccent),
            padding: EdgeInsets.all(16),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                'Menú',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            selected: currentRoute == '/main',
            onTap: () {
              Navigator.pop(context); // Close drawer
              if (onNavigate != null) {
                onNavigate!(0);
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.shopping_bag),
            title: Text('Pedidos'),
            selected: currentRoute == '/pedidos',
            onTap: () {
              Navigator.pop(context); // Close drawer
              if (onNavigate != null) {
                onNavigate!(1);
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Mi Perfil'),
            selected: currentRoute == '/profile',
            onTap: () {
              Navigator.pop(context); // Close drawer
              if (onNavigate != null) {
                onNavigate!(2);
              }
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Salir'),
            onTap: () async {
              
              await audioService.stopMusic();
              await userController.logout();
              
              if (context.mounted) {
                context.go('/login');
              }
            },
          ),
        ],
      ),
    );
  }
}