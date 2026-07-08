import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/errores.dart';
import '../../domain/usecases/obtener_mascotas_uc.dart';
import '../providers/mascota_providers.dart';
import 'mascotas_state.dart';

class MascotasNotifier extends Notifier<MascotasState> {
  late final ObtenerMascotasUc _obtenerMascotas;

  @override
  MascotasState build() {
    _obtenerMascotas = ref.read(obtenerMascotasUcProvider);
    Future.microtask(cargar);
    return const MascotasState(cargando: true);
  }

  Future<void> cargar() async {
    state = state.copyWith(cargando: true, limpiarError: true);
    try {
      final pagina = await _obtenerMascotas(
        pagina: 1,
        busqueda: state.busqueda,
      );
      state = state.copyWith(
        mascotas: pagina.results,
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
      final pagina = await _obtenerMascotas(
        pagina: siguiente,
        busqueda: state.busqueda,
      );
      state = state.copyWith(
        mascotas: [...state.mascotas, ...pagina.results],
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

final mascotasNotifierProvider =
    NotifierProvider<MascotasNotifier, MascotasState>(MascotasNotifier.new);
