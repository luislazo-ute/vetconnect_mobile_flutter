import '../../domain/entities/compra.dart';

class ComprasState {
  final List<Compra> compras;
  final bool cargando;
  final bool cargandoMas;
  final String? error;
  final bool hayMas;
  final int paginaActual;

  const ComprasState({
    this.compras = const [],
    this.cargando = false,
    this.cargandoMas = false,
    this.error,
    this.hayMas = true,
    this.paginaActual = 1,
  });

  ComprasState copyWith({
    List<Compra>? compras,
    bool? cargando,
    bool? cargandoMas,
    String? error,
    bool limpiarError = false,
    bool? hayMas,
    int? paginaActual,
  }) {
    return ComprasState(
      compras: compras ?? this.compras,
      cargando: cargando ?? this.cargando,
      cargandoMas: cargandoMas ?? this.cargandoMas,
      error: limpiarError ? null : (error ?? this.error),
      hayMas: hayMas ?? this.hayMas,
      paginaActual: paginaActual ?? this.paginaActual,
    );
  }
}
