import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/errores.dart';
import '../../domain/usecases/obtener_recetas_uc.dart';
import '../providers/receta_providers.dart';
import 'recetas_state.dart';

class RecetasNotifier extends Notifier<RecetasState> {
  late final ObtenerRecetasUc _obtenerRecetas;

  @override
  RecetasState build() {
    _obtenerRecetas = ref.read(obtenerRecetasUcProvider);
    Future.microtask(cargar);
    return const RecetasState(cargando: true);
  }

  Future<void> cargar() async {
    state = state.copyWith(cargando: true, limpiarError: true);
    try {
      final pagina = await _obtenerRecetas(
        pagina: 1,
        busqueda: state.busqueda,
      );
      state = state.copyWith(
        recetas: pagina.results,
        cargando: false,
        hayMas: pagina.hayMas,
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
      final pagina = await _obtenerRecetas(
        pagina: siguiente,
        busqueda: state.busqueda,
      );
      state = state.copyWith(
        recetas: [...state.recetas, ...pagina.results],
        cargandoMas: false,
        hayMas: pagina.hayMas,
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

final recetasNotifierProvider =
    NotifierProvider<RecetasNotifier, RecetasState>(RecetasNotifier.new);
