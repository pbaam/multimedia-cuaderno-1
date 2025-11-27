import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../l10n/app_localizations.dart';

class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;

  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        switch (index) {
          case 0:
            context.go('/main');
            break;
          case 1:
            context.go('/pedidos');
            break;
          case 2:
            context.go('/profile');
            break;
        }
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.store),
          label: l10n.store,
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
    );
  }
}
