import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/errores.dart';
import '../../domain/usecases/obtener_hospitalizaciones_uc.dart';
import '../providers/hospitalizacion_providers.dart';
import 'hospitalizaciones_state.dart';

class HospitalizacionesNotifier extends Notifier<HospitalizacionesState> {
  late final ObtenerHospitalizacionesUc _obtenerHospitalizaciones;

  @override
  HospitalizacionesState build() {
    _obtenerHospitalizaciones = ref.read(obtenerHospitalizacionesUcProvider);
    Future.microtask(cargar);
    return const HospitalizacionesState(cargando: true);
  }

  Future<void> cargar() async {
    state = state.copyWith(cargando: true, limpiarError: true);
    try {
      final pagina = await _obtenerHospitalizaciones(
        pagina: 1,
        busqueda: state.busqueda,
      );
      state = state.copyWith(
        hospitalizaciones: pagina.results,
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
      final pagina = await _obtenerHospitalizaciones(
        pagina: siguiente,
        busqueda: state.busqueda,
      );
      state = state.copyWith(
        hospitalizaciones: [...state.hospitalizaciones, ...pagina.results],
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

final hospitalizacionesNotifierProvider =
    NotifierProvider<HospitalizacionesNotifier, HospitalizacionesState>(
  HospitalizacionesNotifier.new,
);
