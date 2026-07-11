import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/errores.dart';
import '../../domain/usecases/obtener_categorias_uc.dart';
import '../providers/categoria_providers.dart';
import 'categorias_state.dart';

class CategoriasNotifier extends Notifier<CategoriasState> {
  late final ObtenerCategoriasUc _obtenerCategorias;

  @override
  CategoriasState build() {
    _obtenerCategorias = ref.read(obtenerCategoriasUcProvider);
    Future.microtask(cargar);
    return const CategoriasState(cargando: true);
  }

  Future<void> cargar() async {
    state = state.copyWith(cargando: true, limpiarError: true);
    try {
      final (items: items, hayMas: mas) = await _obtenerCategorias(pagina: 1, busqueda: state.busqueda);
      state = state.copyWith(
        categorias: items,
        cargando: false,
        hayMas: mas,
        paginaActual: 1,
      );
    } on ExcepcionApi catch (e) {
      state = state.copyWith(cargando: false, error: e.mensaje);
    }
  }

  Future<void> cargarMas() async {
    if (state.cargandoMas || !state.hayMas) return;
    state = state.copyWith(cargandoMas: true);
    try {
      final siguiente = state.paginaActual + 1;
      final (items: items, hayMas: mas) = await _obtenerCategorias(pagina: siguiente, busqueda: state.busqueda);
      state = state.copyWith(
        categorias: [...state.categorias, ...items],
        cargandoMas: false,
        hayMas: mas,
        paginaActual: siguiente,
      );
    } on ExcepcionApi catch (e) {
      state = state.copyWith(cargandoMas: false, error: e.mensaje);
    }
  }

  Future<void> buscar(String texto) async {
    state = state.copyWith(busqueda: texto);
    await cargar();
  }
}

final categoriasNotifierProvider =
    NotifierProvider<CategoriasNotifier, CategoriasState>(CategoriasNotifier.new);
