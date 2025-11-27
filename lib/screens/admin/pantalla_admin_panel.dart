import 'package:cuaderno1/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../widgets/common_app_bar_actions.dart';
import '../../controllers/local_user_controller.dart';
import '../../services/audio_service.dart';

class PantallaAdminPanel extends StatelessWidget {
  const PantallaAdminPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.controlPanel),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () async {
            final userController = Provider.of<LocalUserController>(context, listen: false);
            final audioService = Provider.of<AudioService>(context, listen: false);
            
            await audioService.stopMusic();
            await userController.logout();
            
            if (context.mounted) {
              context.go('/login');
            }
          },
        ),
        actions: [
          CommonAppBarActions(),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 800),
          child: Padding(
            padding: EdgeInsets.all(24),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final availableHeight = constraints.maxHeight - 48;
                final cardHeight = (availableHeight - 16) / 2;
                
                return GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: (constraints.maxWidth / 2 - 24) / cardHeight,
                  children: [
                    _buildAdminCard(
                      context,
                      icon: Icons.people,
                      title: l10n.adminUsers,
                      route: '/admin/users',
                      color: Colors.blue,
                    ),
                    _buildAdminCard(
                      context,
                      icon: Icons.inventory_2,
                      title: l10n.adminProducts,
                      route: '/admin/products',
                      color: Colors.green,
                    ),
                    _buildAdminCard(
                      context,
                      icon: Icons.shopping_bag,
                      title: l10n.adminOrders,
                      route: '/admin/orders',
                      color: Colors.orange,
                    ),
                    _buildAdminCard(
                      context,
                      icon: Icons.warehouse,
                      title: l10n.adminInventory,
                      route: '/admin/inventory',
                      color: Colors.purple,
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAdminCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String route,
    required Color color,
  }) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: () => context.go(route),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: color),
            SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
