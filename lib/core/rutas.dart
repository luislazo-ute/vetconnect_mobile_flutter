import 'package:go_router/go_router.dart';

import '../ui/screens/publicas/pantalla_bienvenida.dart';
import '../ui/screens/publicas/pantalla_home.dart';
import '../ui/screens/publicas/pantalla_contacto.dart';
import '../ui/screens/publicas/pantalla_servicios.dart';

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
    GoRoute(
      path: '/contacto',
      name: 'contacto',
      builder: (context, state) => const PantallaContacto(),
    ),
    GoRoute(
      path: '/servicios',
      name: 'servicios',
      builder: (context, state) => const PantallaServicios(),
    ),
    // Aquí irán más rutas en los próximos módulos.
  ],
);
