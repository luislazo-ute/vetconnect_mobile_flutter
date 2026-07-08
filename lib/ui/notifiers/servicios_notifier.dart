import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/errores.dart';
import '../../domain/usecases/obtener_servicios_uc.dart';
import '../providers/servicio_providers.dart';
import 'servicios_state.dart';

class ServiciosNotifier extends Notifier<ServiciosState> {
  late final ObtenerServiciosUc _obtenerServicios;

  @override
  ServiciosState build() {
    _obtenerServicios = ref.read(obtenerServiciosUcProvider);
    Future.microtask(cargar);
    return const ServiciosState(cargando: true);
  }

  Future<void> cargar() async {
    state = state.copyWith(cargando: true, limpiarError: true);
    try {
      final pagina = await _obtenerServicios(
        pagina: 1,
        busqueda: state.busqueda,
      );
      state = state.copyWith(
        servicios: pagina.results,
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
      final pagina = await _obtenerServicios(
        pagina: siguiente,
        busqueda: state.busqueda,
      );
      state = state.copyWith(
        servicios: [...state.servicios, ...pagina.results],
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

final serviciosNotifierProvider =
    NotifierProvider<ServiciosNotifier, ServiciosState>(ServiciosNotifier.new);
