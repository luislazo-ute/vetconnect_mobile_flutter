import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/errores.dart';
import '../../domain/usecases/obtener_servicios_uc.dart';
import '../providers/servicio_providers.dart';
import 'servicios_state.dart';

/// Notifier de la lista de servicios. SOLO llama al use case.
class ServiciosNotifier extends Notifier<ServiciosState> {
  late final ObtenerServiciosUc _obtenerServicios;

  @override
  ServiciosState build() {
    _obtenerServicios = ref.read(obtenerServiciosUcProvider);
    // Diferimos la carga: corre JUSTO DESPUÉS de que build() cree el estado
    // inicial (si la llamáramos directo, tocaría 'state' antes de que exista).
    Future.microtask(cargar);
    return const ServiciosState(cargando: true);
  }

  /// Primera página (o recarga tras una búsqueda).
  Future<void> cargar() async {
    state = state.copyWith(cargando: true, limpiarError: true);
    try {
      final pagina = await _obtenerServicios(pagina: 1, busqueda: state.busqueda);
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

  /// Página siguiente (scroll infinito).
  Future<void> cargarMas() async {
    // Evita cargas duplicadas o pedir cuando ya no queda nada.
    if (state.cargandoMas || !state.hayMas) return;

    state = state.copyWith(cargandoMas: true);
    try {
      final siguiente = state.paginaActual + 1;
      final pagina =
          await _obtenerServicios(pagina: siguiente, busqueda: state.busqueda);
      state = state.copyWith(
        // COMPLETAR: agrega los nuevos al final de los que ya hay (spread).
        // Pista: [...state.servicios, ...pagina.results]
        servicios: [...state.servicios, ...pagina.results],
        cargandoMas: false,
        hayMas: pagina.hayMas,
        paginaActual: siguiente,
      );
    } on ExcepcionApi catch (e) {
      state = state.copyWith(cargandoMas: false, error: e.mensaje);
    }
  }

  /// Nueva búsqueda: guarda el texto y recarga desde la página 1.
  Future<void> buscar(String texto) async {
    state = state.copyWith(busqueda: texto);
    await cargar();
  }
}

/// Provider del notifier (API moderna: NotifierProvider).
final serviciosNotifierProvider =
    NotifierProvider<ServiciosNotifier, ServiciosState>(ServiciosNotifier.new);
