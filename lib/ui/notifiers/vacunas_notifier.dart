import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/errores.dart';
import '../../domain/usecases/obtener_vacunas_uc.dart';
import '../providers/vacuna_providers.dart';
import 'vacunas_state.dart';

class VacunasNotifier extends Notifier<VacunasState> {
  late final ObtenerVacunasUc _obtenerVacunas;

  @override
  VacunasState build() {
    _obtenerVacunas = ref.read(obtenerVacunasUcProvider);
    Future.microtask(cargar);
    return const VacunasState(cargando: true);
  }

  Future<void> cargar() async {
    state = state.copyWith(cargando: true, limpiarError: true);
    try {
      final pagina = await _obtenerVacunas(
        pagina: 1,
        busqueda: state.busqueda,
      );
      state = state.copyWith(
        vacunas: pagina.results,
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
      final pagina = await _obtenerVacunas(
        pagina: siguiente,
        busqueda: state.busqueda,
      );
      state = state.copyWith(
        vacunas: [...state.vacunas, ...pagina.results],
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

final vacunasNotifierProvider =
    NotifierProvider<VacunasNotifier, VacunasState>(VacunasNotifier.new);
