import '../../domain/entities/usuario.dart';

enum EstadoSesion { desconocido, autenticado, noAutenticado }

class EstadoAuth {
  final EstadoSesion sesion;
  final Usuario? usuario;
  final bool cargando;
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
