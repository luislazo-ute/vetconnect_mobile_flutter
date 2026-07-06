import 'package:go_router/go_router.dart';

import '../ui/screens/publicas/pantalla_bienvenida.dart';
import '../ui/screens/publicas/pantalla_home.dart';

/// Configuración central de navegación (como el urls.py de Django).
final GoRouter routerApp = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'bienvenida',
      builder: (context, state) => const PantallaBienvenida(),
    ),
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => const PantallaHome(),
    ),
    // Aquí irán más rutas en los próximos módulos.
  ],
);
