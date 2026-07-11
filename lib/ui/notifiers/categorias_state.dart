import '../../domain/entities/categoria_producto.dart';

class CategoriasState {
  final List<CategoriaProducto> categorias;
  final bool cargando;
  final bool cargandoMas;
  final String? error;
  final bool hayMas;
  final int paginaActual;
  final String busqueda;

  const CategoriasState({
    this.categorias = const [],
    this.cargando = false,
    this.cargandoMas = false,
    this.error,
    this.hayMas = true,
    this.paginaActual = 1,
    this.busqueda = '',
  });

  CategoriasState copyWith({
    List<CategoriaProducto>? categorias,
    bool? cargando,
    bool? cargandoMas,
    String? error,
    bool limpiarError = false,
    bool? hayMas,
    int? paginaActual,
    String? busqueda,
  }) {
    return CategoriasState(
      categorias: categorias ?? this.categorias,
      cargando: cargando ?? this.cargando,
      cargandoMas: cargandoMas ?? this.cargandoMas,
      error: limpiarError ? null : (error ?? this.error),
      hayMas: hayMas ?? this.hayMas,
      paginaActual: paginaActual ?? this.paginaActual,
      busqueda: busqueda ?? this.busqueda,
    );
  }
}
