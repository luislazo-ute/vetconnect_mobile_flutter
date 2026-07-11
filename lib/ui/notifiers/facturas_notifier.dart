import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/errores.dart';
import '../../domain/usecases/obtener_facturas_uc.dart';
import '../providers/factura_providers.dart';
import 'facturas_state.dart';

class FacturasNotifier extends Notifier<FacturasState> {
  late final ObtenerFacturasUc _obtenerFacturas;

  @override
  FacturasState build() {
    _obtenerFacturas = ref.read(obtenerFacturasUcProvider);
    Future.microtask(cargar);
    return const FacturasState(cargando: true);
  }

  Future<void> cargar() async {
    state = state.copyWith(cargando: true, limpiarError: true);
    try {
      final (items: items, hayMas: mas) = await _obtenerFacturas(pagina: 1);
      state = state.copyWith(
        facturas: items,
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
      final (items: items, hayMas: mas) = await _obtenerFacturas(pagina: siguiente);
      state = state.copyWith(
        facturas: [...state.facturas, ...items],
        cargandoMas: false,
        hayMas: mas,
        paginaActual: siguiente,
      );
    } on ExcepcionApi catch (e) {
      state = state.copyWith(cargandoMas: false, error: e.mensaje);
    }
  }
}

final facturasNotifierProvider =
    NotifierProvider<FacturasNotifier, FacturasState>(FacturasNotifier.new);
