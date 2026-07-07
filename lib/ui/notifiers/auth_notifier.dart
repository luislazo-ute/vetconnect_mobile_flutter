import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/errores.dart';
import '../providers/auth_providers.dart';
import 'auth_state.dart';

/// Notifier que maneja la sesión: verificar al arrancar, login y logout.
class AuthNotifier extends Notifier<EstadoAuth> {
  @override
  EstadoAuth build() {
    // Al arrancar, verificamos si ya había sesión guardada.
    Future.microtask(_verificarSesion);
    return const EstadoAuth(); // arranca en "desconocido"
  }

  /// ¿Hay un refresh guardado y sigue válido? Entonces recuperamos la sesión.
  Future<void> _verificarSesion() async {
    final almacenamiento = ref.read(almacenamientoTokensProvider);
    final refresh = await almacenamiento.leerRefresh();

    if (refresh == null) {
      state = state.copyWith(sesion: EstadoSesion.noAutenticado);
      return;
    }
    try {
      // Renovamos el access con el refresh guardado (el refresh rota y se guarda),
      // y luego pedimos el perfil para saber quién es y su rol.
      await ref.read(refrescarTokenUcProvider)(refresh);
      final usuario = await ref.read(obtenerPerfilUcProvider)();
      state = EstadoAuth(sesion: EstadoSesion.autenticado, usuario: usuario);
    } catch (_) {
      // Refresh expirado/ inválido → no hay sesión.
      state = state.copyWith(sesion: EstadoSesion.noAutenticado);
    }
  }

  /// Inicia sesión con usuario y contraseña.
  Future<void> iniciarSesion(String username, String password) async {
    state = state.copyWith(cargando: true, limpiarError: true);
    try {
      final (_, usuario) =
          await ref.read(iniciarSesionUcProvider)(username, password);
      state = EstadoAuth(sesion: EstadoSesion.autenticado, usuario: usuario);
    } on ExcepcionApi catch (e) {
      state = state.copyWith(
        cargando: false,
        error: e.mensaje,
        sesion: EstadoSesion.noAutenticado,
      );
    }
  }

  /// Cierra sesión: avisa al backend (blacklist) y borra tokens locales.
  Future<void> cerrarSesion() async {
    final almacenamiento = ref.read(almacenamientoTokensProvider);
    final refresh = await almacenamiento.leerRefresh();
    if (refresh != null) {
      await ref.read(cerrarSesionUcProvider)(refresh);
    }
    state = const EstadoAuth(sesion: EstadoSesion.noAutenticado);
  }
}

final authNotifierProvider =
    NotifierProvider<AuthNotifier, EstadoAuth>(AuthNotifier.new);
