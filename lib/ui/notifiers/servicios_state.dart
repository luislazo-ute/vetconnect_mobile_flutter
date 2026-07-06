import '../../domain/entities/servicio.dart';

/// Estado inmutable de la pantalla de servicios.
class ServiciosState {
  final List<Servicio> servicios;
  final bool cargando;      // primera carga (spinner central)
  final bool cargandoMas;   // cargando la página siguiente (scroll infinito)
  final String? error;      // mensaje de error, o null si no hay
  final bool hayMas;        // ¿quedan más páginas?
  final int paginaActual;
  final String busqueda;

  const ServiciosState({
    this.servicios = const [],
    this.cargando = false,
    this.cargandoMas = false,
    this.error,
    this.hayMas = true,
    this.paginaActual = 1,
    this.busqueda = '',
  });

  /// Devuelve una COPIA con los campos indicados cambiados.
  ServiciosState copyWith({
    List<Servicio>? servicios,
    bool? cargando,
    bool? cargandoMas,
    String? error,
    bool limpiarError = false, // si es true, pone error en null
    bool? hayMas,
    int? paginaActual,
    String? busqueda,
  }) {
    return ServiciosState(
      servicios: servicios ?? this.servicios,
      cargando: cargando ?? this.cargando,
      cargandoMas: cargandoMas ?? this.cargandoMas,
      // Si limpiarError=true → null; si no, usa el nuevo o conserva el actual.
      error: limpiarError ? null : (error ?? this.error),
      hayMas: hayMas ?? this.hayMas,
      paginaActual: paginaActual ?? this.paginaActual,
      busqueda: busqueda ?? this.busqueda,
    );
  }
}
