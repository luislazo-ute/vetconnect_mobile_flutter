import '../../domain/entities/receta.dart';

class RecetasState {
  final List<Receta> recetas;
  final bool cargando;
  final bool cargandoMas;
  final String? error;
  final bool hayMas;
  final int paginaActual;
  final String busqueda;

  const RecetasState({
    this.recetas = const [],
    this.cargando = false,
    this.cargandoMas = false,
    this.error,
    this.hayMas = true,
    this.paginaActual = 1,
    this.busqueda = '',
  });

  RecetasState copyWith({
    List<Receta>? recetas,
    bool? cargando,
    bool? cargandoMas,
    String? error,
    bool limpiarError = false,
    bool? hayMas,
    int? paginaActual,
    String? busqueda,
  }) {
    return RecetasState(
      recetas: recetas ?? this.recetas,
      cargando: cargando ?? this.cargando,
      cargandoMas: cargandoMas ?? this.cargandoMas,
      error: limpiarError ? null : (error ?? this.error),
      hayMas: hayMas ?? this.hayMas,
      paginaActual: paginaActual ?? this.paginaActual,
      busqueda: busqueda ?? this.busqueda,
    );
  }
}
