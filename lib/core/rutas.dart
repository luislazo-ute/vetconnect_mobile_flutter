import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../domain/entities/veterinario.dart';
import '../ui/notifiers/auth_notifier.dart';
import '../ui/notifiers/auth_state.dart';
import '../ui/screens/privadas/pantalla_dashboard.dart';
import '../ui/screens/publicas/pantalla_bienvenida.dart';
import '../ui/screens/publicas/pantalla_contacto.dart';
import '../ui/screens/publicas/pantalla_equipo.dart';
import '../ui/screens/publicas/pantalla_home.dart';
import '../ui/screens/publicas/pantalla_login.dart';
import '../ui/screens/publicas/pantalla_servicios.dart';
import '../ui/screens/publicas/pantalla_splash.dart';
import '../ui/screens/publicas/pantalla_veterinario_detalle.dart';

/// El router es un provider que OBSERVA la sesión: cuando cambia (login,
/// logout, verificación inicial), se recalcula y el redirect reacciona.
final routerProvider = Provider<GoRouter>((ref) {
  // Observamos SOLO el campo 'sesion' (con select) para no recrear el router
  // en cada cambio menor (como 'cargando').
  final sesion = ref.watch(authNotifierProvider.select((s) => s.sesion));

  return GoRouter(
    // A dónde arranca según la sesión.
    initialLocation: switch (sesion) {
      EstadoSesion.autenticado => '/dashboard',
      EstadoSesion.noAutenticado => '/',
      EstadoSesion.desconocido => '/splash',
    },
    // "Middleware": protege rutas según la sesión.
    redirect: (context, state) {
      final loc = state.matchedLocation;
      final esPrivada = loc.startsWith('/dashboard');

      // Aún verificando: al splash.
      if (sesion == EstadoSesion.desconocido) {
        return loc == '/splash' ? null : '/splash';
      }
      // Ruta privada sin sesión → login.
      if (esPrivada && sesion != EstadoSesion.autenticado) {
        return '/login';
      }
      // Ya logueado pero en login/splash → dashboard.
      if ((loc == '/login' || loc == '/splash') &&
          sesion == EstadoSesion.autenticado) {
        return '/dashboard';
      }
      // Verificación terminó y seguimos en splash sin sesión → inicio público.
      if (loc == '/splash') {
        return '/';
      }
      return null; // sin redirección
    },
    routes: [
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const PantallaSplash(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const PantallaLogin(),
      ),
      GoRoute(
        path: '/dashboard',
        name: 'dashboard',
        builder: (context, state) => const PantallaDashboard(),
      ),
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
      GoRoute(
        path: '/equipo',
        name: 'equipo',
        builder: (context, state) => const PantallaEquipo(),
      ),
      GoRoute(
        path: '/equipo/detalle',
        name: 'veterinarioDetalle',
        builder: (context, state) {
          final vet = state.extra as Veterinario;
          return PantallaVeterinarioDetalle(veterinario: vet);
        },
      ),
    ],
  );
});
