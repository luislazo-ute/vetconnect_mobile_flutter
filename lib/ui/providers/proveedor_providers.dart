import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/proveedor_repository_impl.dart';
import '../../domain/repositories/i_proveedor_repository.dart';
import '../../domain/usecases/actualizar_proveedor_uc.dart';
import '../../domain/usecases/crear_proveedor_uc.dart';
import '../../domain/usecases/eliminar_proveedor_uc.dart';
import '../../domain/usecases/obtener_proveedores_uc.dart';
import 'cliente_autenticado_provider.dart';

final proveedorRepositoryProvider = Provider<IProveedorRepository>((ref) {
  return ProveedorRepositoryImpl(ref.watch(clienteAutenticadoProvider));
});

final obtenerProveedoresUcProvider = Provider<ObtenerProveedoresUc>((ref) {
  return ObtenerProveedoresUc(ref.watch(proveedorRepositoryProvider));
});

final crearProveedorUcProvider = Provider<CrearProveedorUc>((ref) {
  return CrearProveedorUc(ref.watch(proveedorRepositoryProvider));
});

final actualizarProveedorUcProvider = Provider<ActualizarProveedorUc>((ref) {
  return ActualizarProveedorUc(ref.watch(proveedorRepositoryProvider));
});

final eliminarProveedorUcProvider = Provider<EliminarProveedorUc>((ref) {
  return EliminarProveedorUc(ref.watch(proveedorRepositoryProvider));
});
