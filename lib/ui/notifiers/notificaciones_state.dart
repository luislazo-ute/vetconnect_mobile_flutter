import '../../domain/entities/notificacion.dart';

class NotificacionesState {
  final List<Notificacion> notificaciones;
  final bool cargando;
  final bool cargandoMas;
  final String? error;
  final bool hayMas;
  final int paginaActual;
  final String busqueda;

  const NotificacionesState({
    this.notificaciones = const [],
    this.cargando = false,
    this.cargandoMas = false,
    this.error,
    this.hayMas = true,
    this.paginaActual = 1,
    this.busqueda = '',
  });

  NotificacionesState copyWith({
    List<Notificacion>? notificaciones,
    bool? cargando,
    bool? cargandoMas,
    String? error,
    bool limpiarError = false,
    bool? hayMas,
    int? paginaActual,
    String? busqueda,
  }) {
    return NotificacionesState(
      notificaciones: notificaciones ?? this.notificaciones,
      cargando: cargando ?? this.cargando,
      cargandoMas: cargandoMas ?? this.cargandoMas,
      error: limpiarError ? null : (error ?? this.error),
      hayMas: hayMas ?? this.hayMas,
      paginaActual: paginaActual ?? this.paginaActual,
      busqueda: busqueda ?? this.busqueda,
    );
  }
}
