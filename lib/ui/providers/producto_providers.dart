import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/producto_repository_impl.dart';
import '../../data/repositories/servicio_admin_repository_impl.dart';
import '../../domain/entities/producto.dart';
import '../../domain/repositories/i_producto_repository.dart';
import '../../domain/repositories/i_servicio_repository_ext.dart';
import '../../domain/usecases/actualizar_producto_uc.dart';
import '../../domain/usecases/actualizar_servicio_uc.dart';
import '../../domain/usecases/crear_producto_uc.dart';
import '../../domain/usecases/crear_servicio_uc.dart';
import '../../domain/usecases/eliminar_producto_uc.dart';
import '../../domain/usecases/eliminar_servicio_uc.dart';
import '../../domain/usecases/obtener_producto_por_id_uc.dart';
import '../../domain/usecases/obtener_productos_uc.dart';
import 'cliente_autenticado_provider.dart';

final productoRepositoryProvider = Provider<IProductoRepository>((ref) {
  return ProductoRepositoryImpl(ref.watch(clienteAutenticadoProvider));
});

final obtenerProductosUcProvider = Provider<ObtenerProductosUc>((ref) {
  return ObtenerProductosUc(ref.watch(productoRepositoryProvider));
});

final crearProductoUcProvider = Provider<CrearProductoUc>((ref) {
  return CrearProductoUc(ref.watch(productoRepositoryProvider));
});

final actualizarProductoUcProvider = Provider<ActualizarProductoUc>((ref) {
  return ActualizarProductoUc(ref.watch(productoRepositoryProvider));
});

final eliminarProductoUcProvider = Provider<EliminarProductoUc>((ref) {
  return EliminarProductoUc(ref.watch(productoRepositoryProvider));
});

final obtenerProductoPorIdUcProvider = Provider<ObtenerProductoPorIdUc>((ref) {
  return ObtenerProductoPorIdUc(ref.watch(productoRepositoryProvider));
});

final productoDetalleProvider = FutureProvider.family<Producto?, int>((ref, id) {
  return ref.watch(obtenerProductoPorIdUcProvider)(id);
});

// --- Servicios admin ---
final servicioAdminRepositoryProvider = Provider<IServicioAdminRepository>((ref) {
  return ServicioAdminRepositoryImpl(ref.watch(clienteAutenticadoProvider));
});

final crearServicioUcProvider = Provider<CrearServicioUc>((ref) {
  return CrearServicioUc(ref.watch(servicioAdminRepositoryProvider));
});

final actualizarServicioUcProvider = Provider<ActualizarServicioUc>((ref) {
  return ActualizarServicioUc(ref.watch(servicioAdminRepositoryProvider));
});

final eliminarServicioUcProvider = Provider<EliminarServicioUc>((ref) {
  return EliminarServicioUc(ref.watch(servicioAdminRepositoryProvider));
});
