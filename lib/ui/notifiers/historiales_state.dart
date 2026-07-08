import '../../domain/entities/historial.dart';

class HistorialesState {
  final List<Historial> historiales;
  final bool cargando;
  final bool cargandoMas;
  final String? error;
  final bool hayMas;
  final int paginaActual;
  final String busqueda;

  const HistorialesState({
    this.historiales = const [],
    this.cargando = false,
    this.cargandoMas = false,
    this.error,
    this.hayMas = true,
    this.paginaActual = 1,
    this.busqueda = '',
  });

  HistorialesState copyWith({
    List<Historial>? historiales,
    bool? cargando,
    bool? cargandoMas,
    String? error,
    bool limpiarError = false,
    bool? hayMas,
    int? paginaActual,
    String? busqueda,
  }) {
    return HistorialesState(
      historiales: historiales ?? this.historiales,
      cargando: cargando ?? this.cargando,
      cargandoMas: cargandoMas ?? this.cargandoMas,
      error: limpiarError ? null : (error ?? this.error),
      hayMas: hayMas ?? this.hayMas,
      paginaActual: paginaActual ?? this.paginaActual,
      busqueda: busqueda ?? this.busqueda,
    );
  }
}
