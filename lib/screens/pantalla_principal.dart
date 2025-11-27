import 'package:cuaderno1/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:provider/provider.dart';
import '../widgets/drawer_general.dart';
import '../widgets/common_app_bar.dart';
import '../widgets/app_drawer.dart';
import '../widgets/app_bottom_nav_bar.dart';
import '../services/audio_service.dart';
import 'user/pantalla_home.dart';
import 'user/pantalla_pedidos.dart';
import 'user/pantalla_yo.dart';

class PantallaPrincipal extends StatefulWidget {
  final int? initialIndex;
  
  const PantallaPrincipal({super.key, this.initialIndex});

  @override
  State<PantallaPrincipal> createState() => _PantallaPrincipalState();
}

class _PantallaPrincipalState extends State<PantallaPrincipal> {
  late int _selectedIndex;

  final List<Widget> _screens = [
    PantallaHome(),
    PantallaPedidos(),
    PantallaYo(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex ?? 0;
  }

  void _onNavTap(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: CommonAppBar(title: l10n.mainPage),
      drawer: AppDrawer(),
      body: Center(
        child: _screens[_selectedIndex],
      ),
      bottomNavigationBar: AppBottomNavBar(currentIndex: 0),
    );
  }
}