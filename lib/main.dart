import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'l10n/app_localizations.dart';
import 'controllers/local_user_controller.dart';
import 'controllers/product_service.dart';
import 'controllers/order_service.dart';
import 'config/utils/language_service.dart';
import 'services/audio_service.dart';
import 'screens/pantalla_principal.dart';
import 'screens/user/pantalla_perfil.dart';
import 'screens/pantalla_registro.dart';
import 'screens/pantalla_inicio_sesion.dart';
import 'screens/user/pantalla_pedidos.dart';
import 'screens/user/pantalla_editar_perfil.dart';
import 'screens/admin/pantalla_admin_panel.dart';
import 'screens/admin/pantalla_admin_usuarios.dart';
import 'screens/admin/pantalla_admin_productos.dart';
import 'screens/admin/pantalla_admin_pedidos.dart';
import 'screens/admin/pantalla_admin_inventario.dart';
import 'models/user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final languageService = LanguageService();
  await languageService.initialize();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocalUserController()),
        ChangeNotifierProvider(create: (_) => ProductService()),
        ChangeNotifierProvider(create: (_) => OrderService()),
        ChangeNotifierProvider(create: (_) => AudioService()),
        ChangeNotifierProvider.value(value: languageService),
      ],
      child: App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final userController = Provider.of<LocalUserController>(context, listen: false);
    
    final router = GoRouter(
      initialLocation: '/login',
      redirect: (context, state) async {
        await userController.initializeSession();
        final isLoggedIn = userController.isLoggedIn;
        final isAdmin = userController.user?.role == UserRole.administrator;
        final isGoingToAuth = state.matchedLocation == '/login' || 
                              state.matchedLocation == '/register';
        final isGoingToAdmin = state.matchedLocation.startsWith('/admin');

        // Redirect logged-in users away from auth pages
        if (isLoggedIn && isGoingToAuth) {
          return isAdmin ? '/admin' : '/main';
        }

        // Redirect non-logged-in users to login
        if (!isLoggedIn && !isGoingToAuth) {
          return '/login';
        }

        // Redirect non-admin users away from admin pages
        if (isGoingToAdmin && !isAdmin) {
          return '/main';
        }

        // Redirect admin users away from regular user pages
        if (isAdmin && state.matchedLocation == '/main') {
          return '/admin';
        }

        return null;
      },
      routes: [
        GoRoute(
          path: '/login',
          name: 'login',
          builder: (context, state) => PantallaInicioSesion(),
        ),
        GoRoute(
          path: '/register',
          name: 'register',
          builder: (context, state) => PantallaRegistro(),
        ),
        GoRoute(
          path: '/main',
          name: 'main',
          builder: (context, state) => PantallaPrincipal(),
        ),
        GoRoute(
          path: '/profile',
          name: 'profile',
          builder: (context, state) => PantallaPerfil(),
        ),
        GoRoute(
          path: '/pedidos',
          name: 'pedidos',
          builder: (context, state) => PantallaPedidos(),
        ),
        GoRoute(
          path: '/edit-profile',
          name: 'edit-profile',
          builder: (context, state) => PantallaEditarPerfil(),
        ),
        GoRoute(
          path: '/admin',
          name: 'admin',
          builder: (context, state) => PantallaAdminPanel(),
        ),
        GoRoute(
          path: '/admin/users',
          name: 'admin-users',
          builder: (context, state) => PantallaAdminUsuarios(),
        ),
        GoRoute(
          path: '/admin/products',
          name: 'admin-products',
          builder: (context, state) => PantallaAdminProductos(),
        ),
        GoRoute(
          path: '/admin/orders',
          name: 'admin-orders',
          builder: (context, state) => PantallaAdminPedidos(),
        ),
        GoRoute(
          path: '/admin/inventory',
          name: 'admin-inventory',
          builder: (context, state) => PantallaAdminInventario(),
        ),
      ],
    );

    return Consumer<LanguageService>(
      builder: (context, languageService, child) {
        return MaterialApp.router(
          title: 'Cuaderno 1',
          debugShowCheckedModeBanner: false,
          locale: languageService.currentLocale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'),
            Locale('es'),
          ],
          theme: ThemeData(
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.lightBlueAccent,
              foregroundColor: Colors.white,
            ),
          ),
          routerConfig: router,
        );
      },
    );
  }
}