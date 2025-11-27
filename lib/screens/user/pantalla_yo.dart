import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../controllers/local_user_controller.dart';
import '../../widgets/language_button.dart';
import '../../services/audio_service.dart';
import '../../l10n/app_localizations.dart';

class PantallaYo extends StatelessWidget {
  const PantallaYo({super.key});

  @override
  Widget build(BuildContext context) {
    final userController = Provider.of<LocalUserController>(context);
    final user = userController.user;
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.lightBlueAccent,
              child: Text(
                user?.name[0].toUpperCase() ?? 'U',
                style: TextStyle(fontSize: 40, color: Colors.white),
              ),
            ),
            SizedBox(height: 16),
            Text(
              user?.name ?? l10n.user,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(user?.email ?? ''),
            SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () => context.go('/pedidos'),
              icon: Icon(Icons.shopping_bag),
              label: Text(l10n.myOrders),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlueAccent,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                minimumSize: Size(double.infinity, 0),
              ),
            ),
            SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () => context.go('/edit-profile'),
              icon: Icon(Icons.edit),
              label: Text(l10n.editUser),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.lightBlueAccent,
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                minimumSize: Size(double.infinity, 0),
              ),
            ),
            SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () async {
                final audioService = Provider.of<AudioService>(context, listen: false);
                await audioService.stopMusic();
                await userController.logout();
                if (context.mounted) {
                  context.go('/login');
                }
              },
              icon: Icon(Icons.logout),
              label: Text(l10n.closeSession),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                minimumSize: Size(double.infinity, 0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
