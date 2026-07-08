import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/errores.dart';
import '../../domain/usecases/obtener_historiales_uc.dart';
import '../providers/historial_providers.dart';
import 'historiales_state.dart';

class HistorialesNotifier extends Notifier<HistorialesState> {
  late final ObtenerHistorialesUc _obtener;

  @override
  HistorialesState build() {
    _obtener = ref.read(obtenerHistorialesUcProvider);
    Future.microtask(cargar);
    return const HistorialesState(cargando: true);
  }

  Future<void> cargar() async {
    state = state.copyWith(cargando: true, limpiarError: true);
    try {
      final pagina = await _obtener(pagina: 1, busqueda: state.busqueda);
      state = state.copyWith(
        historiales: pagina.results,
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
      final pagina = await _obtener(pagina: siguiente, busqueda: state.busqueda);
      state = state.copyWith(
        historiales: [...state.historiales, ...pagina.results],
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

final historialesNotifierProvider =
    NotifierProvider<HistorialesNotifier, HistorialesState>(
        HistorialesNotifier.new);
