import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../l10n/app_localizations.dart';
import '../controllers/local_user_controller.dart';
import '../services/audio_service.dart';
import '../config/resources/app_colors.dart';
import '../config/resources/app_dimensions.dart';

class DrawerAdmin extends StatelessWidget {
  const DrawerAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final userController = Provider.of<LocalUserController>(context);
    final user = userController.user;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: AppColors.primary,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CircleAvatar(
                  radius: AppDimensions.spacing30,
                  backgroundColor: AppColors.white,
                  child: Icon(
                    Icons.admin_panel_settings,
                    size: AppDimensions.spacing35,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(height: AppDimensions.spacing10),
                Text(
                  user?.name ?? '',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: AppDimensions.fontSize18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  l10n.admin,
                  style: TextStyle(
                    color: AppColors.white70,
                    fontSize: AppDimensions.fontSize14,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.dashboard),
            title: Text(l10n.controlPanel),
            onTap: () {
              Navigator.pop(context);
              context.go('/admin');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.home),
            title: Text(l10n.home),
            onTap: () {
              Navigator.pop(context);
              context.go('/main');
            },
          ),
          ListTile(
            leading: Icon(Icons.shopping_bag),
            title: Text(l10n.orders),
            onTap: () {
              Navigator.pop(context);
              context.go('/pedidos');
            },
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text(l10n.myProfile),
            onTap: () {
              Navigator.pop(context);
              context.go('/profile');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout, color: AppColors.red),
            title: Text(l10n.logout, style: TextStyle(color: AppColors.red)),
            onTap: () async {
              final userController = Provider.of<LocalUserController>(context, listen: false);
              final audioService = Provider.of<AudioService>(context, listen: false);
              
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
