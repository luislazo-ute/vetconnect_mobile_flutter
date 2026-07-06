import 'package:go_router/go_router.dart';

import '../main.dart'; // para usar PantallaInicio (temporal; luego moveremos las pantallas)


/// Configuración central de navegación (como el urls.py de Django).
final GoRouter routerApp = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'inicio',
      // El builder devuelve LA PANTALLA que se dibuja en esta ruta.
      builder: (context, state) => const PantallaInicio(),
    ),
    // Aquí irán más rutas en los próximos módulos.
  ],
);
