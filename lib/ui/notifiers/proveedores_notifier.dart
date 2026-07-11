import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/errores.dart';
import '../../domain/usecases/obtener_proveedores_uc.dart';
import '../providers/proveedor_providers.dart';
import 'proveedores_state.dart';

class ProveedoresNotifier extends Notifier<ProveedoresState> {
  late final ObtenerProveedoresUc _obtenerProveedores;

  @override
  ProveedoresState build() {
    _obtenerProveedores = ref.read(obtenerProveedoresUcProvider);
    Future.microtask(cargar);
    return const ProveedoresState(cargando: true);
  }

  Future<void> cargar() async {
    state = state.copyWith(cargando: true, limpiarError: true);
    try {
      final (items: items, hayMas: mas) =
          await _obtenerProveedores(pagina: 1, busqueda: state.busqueda);
      state = state.copyWith(
        proveedores: items,
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
      final (items: items, hayMas: mas) =
          await _obtenerProveedores(pagina: siguiente, busqueda: state.busqueda);
      state = state.copyWith(
        proveedores: [...state.proveedores, ...items],
        cargandoMas: false,
        hayMas: mas,
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

final proveedoresNotifierProvider =
    NotifierProvider<ProveedoresNotifier, ProveedoresState>(
        ProveedoresNotifier.new);
