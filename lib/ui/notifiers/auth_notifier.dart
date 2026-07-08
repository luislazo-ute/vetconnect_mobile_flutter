import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/errores.dart';
import '../providers/auth_providers.dart';
import 'auth_state.dart';

class AuthNotifier extends Notifier<EstadoAuth> {
  @override
  EstadoAuth build() {
    Future.microtask(_verificarSesion);
    return const EstadoAuth();
  }

  Future<void> _verificarSesion() async {
    final almacenamiento = ref.read(almacenamientoTokensProvider);
    final refresh = await almacenamiento.leerRefresh();

    if (refresh == null) {
      state = state.copyWith(sesion: EstadoSesion.noAutenticado);
      return;
    }
    try {
      await ref.read(refrescarTokenUcProvider)(refresh);
      final usuario = await ref.read(obtenerPerfilUcProvider)();
      state = EstadoAuth(sesion: EstadoSesion.autenticado, usuario: usuario);
    } catch (_) {
      state = state.copyWith(sesion: EstadoSesion.noAutenticado);
    }
  }

  Future<void> iniciarSesion(String username, String password) async {
    state = state.copyWith(cargando: true, limpiarError: true);
    try {
      final (_, usuario) = await ref.read(iniciarSesionUcProvider)(
        username,
        password,
      );
      state = EstadoAuth(sesion: EstadoSesion.autenticado, usuario: usuario);
    } on ExcepcionApi catch (e) {
      state = state.copyWith(
        cargando: false,
        error: e.mensaje,
        sesion: EstadoSesion.noAutenticado,
      );
    }
  }

  Future<void> cerrarSesion() async {
    final almacenamiento = ref.read(almacenamientoTokensProvider);
    final refresh = await almacenamiento.leerRefresh();
    if (refresh != null) {
      await ref.read(cerrarSesionUcProvider)(refresh);
    }
    state = const EstadoAuth(sesion: EstadoSesion.noAutenticado);
  }
}

final authNotifierProvider = NotifierProvider<AuthNotifier, EstadoAuth>(
  AuthNotifier.new,
);
