import '../../domain/entities/veterinario.dart';

/// Estado inmutable de la pantalla de veterinarios (gemelo de ServiciosState).
class VeterinariosState {
  final List<Veterinario> veterinarios;
  final bool cargando;
  final bool cargandoMas;
  final String? error;
  final bool hayMas;
  final int paginaActual;
  final String busqueda;

  const VeterinariosState({
    this.veterinarios = const [],
    this.cargando = false,
    this.cargandoMas = false,
    this.error,
    this.hayMas = true,
    this.paginaActual = 1,
    this.busqueda = '',
  });

  VeterinariosState copyWith({
    List<Veterinario>? veterinarios,
    bool? cargando,
    bool? cargandoMas,
    String? error,
    bool limpiarError = false,
    bool? hayMas,
    int? paginaActual,
    String? busqueda,
  }) {
    return VeterinariosState(
      veterinarios: veterinarios ?? this.veterinarios,
      cargando: cargando ?? this.cargando,
      cargandoMas: cargandoMas ?? this.cargandoMas,
      error: limpiarError ? null : (error ?? this.error),
      hayMas: hayMas ?? this.hayMas,
      paginaActual: paginaActual ?? this.paginaActual,
      busqueda: busqueda ?? this.busqueda,
    );
  }
}
