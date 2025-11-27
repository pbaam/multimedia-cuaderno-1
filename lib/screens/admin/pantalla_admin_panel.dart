import 'package:cuaderno1/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../widgets/common_app_bar.dart';
import '../../widgets/app_drawer.dart';
import '../../controllers/local_user_controller.dart';
import '../../services/audio_service.dart';
import '../../widgets/common_app_bar_actions.dart';
import '../../config/resources/app_colors.dart';
import '../../config/resources/app_dimensions.dart';

class PantallaAdminPanel extends StatelessWidget {
  const PantallaAdminPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final userController = Provider.of<LocalUserController>(context);
    final isRootAdmin = userController.user?.name.toLowerCase() == 'admin';

    return Scaffold(
      appBar: isRootAdmin
          ? AppBar(
              title: Text(l10n.controlPanel),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () async {
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
            )
          : CommonAppBar(title: l10n.controlPanel),
      drawer: isRootAdmin ? null : AppDrawer(),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: AppDimensions.maxWidth800),
          child: Padding(
            padding: EdgeInsets.all(AppDimensions.spacing24),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final availableHeight = constraints.maxHeight - AppDimensions.spacing48;
                final cardHeight = (availableHeight - AppDimensions.spacing16) / 2;
                
                return GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: AppDimensions.spacing16,
                  mainAxisSpacing: AppDimensions.spacing16,
                  childAspectRatio: (constraints.maxWidth / 2 - AppDimensions.spacing24) / cardHeight,
                  children: [
                    _buildAdminCard(
                      context,
                      icon: Icons.people,
                      title: l10n.adminUsers,
                      route: '/admin/users',
                      color: AppColors.blue,
                    ),
                    _buildAdminCard(
                      context,
                      icon: Icons.inventory_2,
                      title: l10n.adminProducts,
                      route: '/admin/products',
                      color: AppColors.green,
                    ),
                    _buildAdminCard(
                      context,
                      icon: Icons.shopping_bag,
                      title: l10n.adminOrders,
                      route: '/admin/orders',
                      color: AppColors.orange,
                    ),
                    _buildAdminCard(
                      context,
                      icon: Icons.warehouse,
                      title: l10n.adminInventory,
                      route: '/admin/inventory',
                      color: AppColors.purple,
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
            Icon(icon, size: AppDimensions.spacing64, color: color),
            SizedBox(height: AppDimensions.spacing16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppDimensions.fontSize16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
