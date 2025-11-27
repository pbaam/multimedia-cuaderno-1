import 'package:cuaderno1/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/common_app_bar.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/app_bottom_nav_bar.dart';

import '../../controllers/local_user_controller.dart';
import 'pantalla_yo.dart';

class PantallaPerfil extends StatefulWidget {
  const PantallaPerfil ({super.key});

  @override
  State<PantallaPerfil> createState() => _PantallaPerfil();
}

class _PantallaPerfil extends State<PantallaPerfil> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: CommonAppBar(title: l10n.myProfile),
      drawer: AppDrawer(),
      body: Consumer<LocalUserController>(
        builder: (context, userController, child) {
          return PantallaYo();
        },
      ),
      bottomNavigationBar: AppBottomNavBar(currentIndex: 2),
    );
  }
}