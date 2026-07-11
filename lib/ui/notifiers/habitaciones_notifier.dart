import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/errores.dart';
import '../../domain/usecases/obtener_habitaciones_uc.dart';
import '../providers/habitacion_providers.dart';
import 'habitaciones_state.dart';

class HabitacionesNotifier extends Notifier<HabitacionesState> {
  late final ObtenerHabitacionesUc _obtenerHabitaciones;

  @override
  HabitacionesState build() {
    _obtenerHabitaciones = ref.read(obtenerHabitacionesUcProvider);
    Future.microtask(cargar);
    return const HabitacionesState(cargando: true);
  }

  Future<void> cargar() async {
    state = state.copyWith(cargando: true, limpiarError: true);
    try {
      final pagina = await _obtenerHabitaciones(
        pagina: 1,
        busqueda: state.busqueda,
      );
      state = state.copyWith(
        habitaciones: pagina.results,
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
      final pagina = await _obtenerHabitaciones(
        pagina: siguiente,
        busqueda: state.busqueda,
      );
      state = state.copyWith(
        habitaciones: [...state.habitaciones, ...pagina.results],
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

final habitacionesNotifierProvider =
    NotifierProvider<HabitacionesNotifier, HabitacionesState>(
  HabitacionesNotifier.new,
);
