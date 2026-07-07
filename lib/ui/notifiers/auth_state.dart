import '../../domain/entities/usuario.dart';

/// Momentos posibles de la sesión.
enum EstadoSesion { desconocido, autenticado, noAutenticado }

/// Estado inmutable de autenticación.
class EstadoAuth {
  final EstadoSesion sesion;
  final Usuario? usuario; // el usuario logueado (null si no hay sesión)
  final bool cargando;    // true mientras se procesa el login
  final String? error;

  const EstadoAuth({
    this.sesion = EstadoSesion.desconocido,
    this.usuario,
    this.cargando = false,
    this.error,
  });

  EstadoAuth copyWith({
    EstadoSesion? sesion,
    Usuario? usuario,
    bool? cargando,
    String? error,
    bool limpiarError = false,
  }) {
    return EstadoAuth(
      sesion: sesion ?? this.sesion,
      usuario: usuario ?? this.usuario,
      cargando: cargando ?? this.cargando,
      error: limpiarError ? null : (error ?? this.error),
    );
  }
}
