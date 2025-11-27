import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../l10n/app_localizations.dart';
import '../controllers/local_user_controller.dart';
import '../services/audio_service.dart';
import '../models/user.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final userController = Provider.of<LocalUserController>(context);
    final user = userController.user;
    final isAdmin = user?.role == UserRole.administrator;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.lightBlueAccent,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  backgroundImage: user?.imagePath != null
                      ? (kIsWeb
                          ? NetworkImage(user!.imagePath!)
                          : FileImage(File(user!.imagePath!)) as ImageProvider)
                      : null,
                  child: user?.imagePath == null
                      ? Icon(
                          isAdmin ? Icons.admin_panel_settings : Icons.person,
                          size: 35,
                          color: Colors.lightBlueAccent,
                        )
                      : null,
                ),
                SizedBox(height: 10),
                Text(
                  user?.name ?? '',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  isAdmin ? l10n.admin : l10n.user,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          // Admin Panel - only for admins
          if (isAdmin) ...[
            ListTile(
              leading: Icon(Icons.dashboard),
              title: Text(l10n.controlPanel),
              onTap: () {
                Navigator.pop(context);
                context.go('/admin');
              },
            ),
            Divider(),
          ],
          // Home
          ListTile(
            leading: Icon(Icons.home),
            title: Text(l10n.home),
            onTap: () {
              Navigator.pop(context);
              context.go('/main');
            },
          ),
          // Orders
          ListTile(
            leading: Icon(Icons.shopping_bag),
            title: Text(l10n.orders),
            onTap: () {
              Navigator.pop(context);
              context.go('/pedidos');
            },
          ),
          // Profile
          ListTile(
            leading: Icon(Icons.person),
            title: Text(l10n.myProfile),
            onTap: () {
              Navigator.pop(context);
              context.go('/profile');
            },
          ),
          Divider(),
          // Logout
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text(l10n.logout, style: TextStyle(color: Colors.red)),
            onTap: () async {
              final audioService = Provider.of<AudioService>(context, listen: false);
              
              await audioService.stopMusic();
              await userController.logout();
              
              if (context.mounted) {
                Navigator.pop(context);
                context.go('/login');
              }
            },
          ),
        ],
      ),
    );
  }
}
