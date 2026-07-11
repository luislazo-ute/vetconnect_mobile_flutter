import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/errores.dart';
import '../../domain/usecases/obtener_compras_uc.dart';
import '../providers/compra_providers.dart';
import 'compras_state.dart';

class ComprasNotifier extends Notifier<ComprasState> {
  late final ObtenerComprasUc _obtenerCompras;

  @override
  ComprasState build() {
    _obtenerCompras = ref.read(obtenerComprasUcProvider);
    Future.microtask(cargar);
    return const ComprasState(cargando: true);
  }

  Future<void> cargar() async {
    state = state.copyWith(cargando: true, limpiarError: true);
    try {
      final (items: items, hayMas: mas) = await _obtenerCompras(pagina: 1);
      state = state.copyWith(
        compras: items,
        cargando: false,
        hayMas: mas,
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
      final (items: items, hayMas: mas) = await _obtenerCompras(pagina: siguiente);
      state = state.copyWith(
        compras: [...state.compras, ...items],
        cargandoMas: false,
        hayMas: mas,
        paginaActual: siguiente,
      );
    } on ExcepcionApi catch (e) {
      state = state.copyWith(cargandoMas: false, error: e.mensaje);
    }
  }
}

final comprasNotifierProvider =
    NotifierProvider<ComprasNotifier, ComprasState>(ComprasNotifier.new);
