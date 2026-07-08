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

final routerProvider = Provider<GoRouter>((ref) {
  final sesion = ref.watch(authNotifierProvider.select((s) => s.sesion));

  return GoRouter(
    initialLocation: switch (sesion) {
      EstadoSesion.autenticado => '/dashboard',
      EstadoSesion.noAutenticado => '/',
      EstadoSesion.desconocido => '/splash',
    },
    redirect: (context, state) {
      final loc = state.matchedLocation;
      final esPrivada = loc.startsWith('/dashboard');

      if (sesion == EstadoSesion.desconocido) {
        return loc == '/splash' ? null : '/splash';
      }
      if (esPrivada && sesion != EstadoSesion.autenticado) {
        return '/login';
      }
      if ((loc == '/login' || loc == '/splash') &&
          sesion == EstadoSesion.autenticado) {
        return '/dashboard';
      }
      if (loc == '/splash') {
        return '/';
      }
      return null;
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
