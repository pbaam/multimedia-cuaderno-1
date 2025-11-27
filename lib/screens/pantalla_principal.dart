import 'package:cuaderno1/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:provider/provider.dart';
import '../widgets/drawer_general.dart';
import '../widgets/common_app_bar_actions.dart';
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
    
    final List<String> _titles = [
      l10n.home,
      l10n.orders,
      l10n.me,
    ];
    
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        actions: [
          CommonAppBarActions(),
        ],
      ),
      body: _screens[_selectedIndex],
      drawer: DrawerGeneral(onNavigate: _onNavTap),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onNavTap,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: l10n.home,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: l10n.orders,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: l10n.me,
          ),
        ],
      ),
    );
  }
}