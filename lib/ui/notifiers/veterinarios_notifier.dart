import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/errores.dart';
import '../../domain/usecases/obtener_veterinarios_uc.dart';
import '../providers/veterinario_providers.dart';
import 'veterinarios_state.dart';

class VeterinariosNotifier extends Notifier<VeterinariosState> {
  late final ObtenerVeterinariosUc _obtenerVeterinarios;

  @override
  VeterinariosState build() {
    _obtenerVeterinarios = ref.read(obtenerVeterinariosUcProvider);
    Future.microtask(cargar);
    return const VeterinariosState(cargando: true);
  }

  Future<void> cargar() async {
    state = state.copyWith(cargando: true, limpiarError: true);
    try {
      final pagina = await _obtenerVeterinarios(
        pagina: 1,
        busqueda: state.busqueda,
      );
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

  Future<void> cargarMas() async {
    if (state.cargandoMas || !state.hayMas) return;

    state = state.copyWith(cargandoMas: true);
    try {
      final siguiente = state.paginaActual + 1;
      final pagina = await _obtenerVeterinarios(
        pagina: siguiente,
        busqueda: state.busqueda,
      );
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

  Future<void> buscar(String texto) async {
    state = state.copyWith(busqueda: texto);
    await cargar();
  }
}

final veterinariosNotifierProvider =
    NotifierProvider<VeterinariosNotifier, VeterinariosState>(
      VeterinariosNotifier.new,
    );
