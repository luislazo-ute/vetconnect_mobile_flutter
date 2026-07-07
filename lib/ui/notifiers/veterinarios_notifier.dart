import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/errores.dart';
import '../../domain/usecases/obtener_veterinarios_uc.dart';
import '../providers/veterinario_providers.dart';
import 'veterinarios_state.dart';

/// Notifier de la lista de veterinarios. SOLO llama al use case.
class VeterinariosNotifier extends Notifier<VeterinariosState> {
  late final ObtenerVeterinariosUc _obtenerVeterinarios;

  @override
  VeterinariosState build() {
    _obtenerVeterinarios = ref.read(obtenerVeterinariosUcProvider);
    // Diferimos la carga para no tocar 'state' antes de que build() lo cree.
    Future.microtask(cargar);
    return const VeterinariosState(cargando: true);
  }

  /// Primera página (o recarga tras una búsqueda).
  Future<void> cargar() async {
    state = state.copyWith(cargando: true, limpiarError: true);
    try {
      final pagina = await _obtenerVeterinarios(pagina: 1, busqueda: state.busqueda);
      state = state.copyWith(
        veterinarios: pagina.results,
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
    if (state.cargandoMas || !state.hayMas) return;

    state = state.copyWith(cargandoMas: true);
    try {
      final siguiente = state.paginaActual + 1;
      final pagina =
          await _obtenerVeterinarios(pagina: siguiente, busqueda: state.busqueda);
      state = state.copyWith(
        veterinarios: [...state.veterinarios, ...pagina.results],
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

final veterinariosNotifierProvider =
    NotifierProvider<VeterinariosNotifier, VeterinariosState>(
        VeterinariosNotifier.new);
