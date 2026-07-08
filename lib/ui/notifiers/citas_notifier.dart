import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/errores.dart';
import '../../domain/usecases/obtener_citas_uc.dart';
import '../providers/cita_providers.dart';
import 'citas_state.dart';

class CitasNotifier extends Notifier<CitasState> {
  late final ObtenerCitasUc _obtenerCitas;

  @override
  CitasState build() {
    _obtenerCitas = ref.read(obtenerCitasUcProvider);
    Future.microtask(cargar);
    return const CitasState(cargando: true);
  }

  Future<void> cargar() async {
    state = state.copyWith(cargando: true, limpiarError: true);
    try {
      final pagina = await _obtenerCitas(pagina: 1, busqueda: state.busqueda);
      state = state.copyWith(
        citas: pagina.results,
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
      final pagina = await _obtenerCitas(
        pagina: siguiente,
        busqueda: state.busqueda,
      );
      state = state.copyWith(
        citas: [...state.citas, ...pagina.results],
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

final citasNotifierProvider = NotifierProvider<CitasNotifier, CitasState>(
  CitasNotifier.new,
);
