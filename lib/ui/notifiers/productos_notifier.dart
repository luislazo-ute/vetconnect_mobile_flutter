import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/errores.dart';
import '../../domain/usecases/obtener_productos_uc.dart';
import '../providers/producto_providers.dart';
import 'productos_state.dart';

class ProductosNotifier extends Notifier<ProductosState> {
  late final ObtenerProductosUc _obtenerProductos;

  @override
  ProductosState build() {
    _obtenerProductos = ref.read(obtenerProductosUcProvider);
    Future.microtask(cargar);
    return const ProductosState(cargando: true);
  }

  Future<void> cargar() async {
    state = state.copyWith(cargando: true, limpiarError: true);
    try {
      final (items: items, hayMas: mas) = await _obtenerProductos(pagina: 1, busqueda: state.busqueda);
      state = state.copyWith(
        productos: items,
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
      final (items: items, hayMas: mas) = await _obtenerProductos(pagina: siguiente, busqueda: state.busqueda);
      state = state.copyWith(
        productos: [...state.productos, ...items],
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

final productosNotifierProvider =
    NotifierProvider<ProductosNotifier, ProductosState>(ProductosNotifier.new);
