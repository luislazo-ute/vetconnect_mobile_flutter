import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/categoria_producto_repository_impl.dart';
import '../../domain/entities/categoria_producto.dart';
import '../../domain/repositories/i_categoria_producto_repository.dart';
import '../../domain/usecases/actualizar_categoria_uc.dart';
import '../../domain/usecases/crear_categoria_uc.dart';
import '../../domain/usecases/eliminar_categoria_uc.dart';
import '../../domain/usecases/obtener_categoria_por_id_uc.dart';
import '../../domain/usecases/obtener_categorias_uc.dart';
import 'cliente_autenticado_provider.dart';

final categoriaRepositoryProvider = Provider<ICategoriaProductoRepository>((ref) {
  final cliente = ref.watch(clienteAutenticadoProvider);
  return CategoriaProductoRepositoryImpl(cliente);
});

final obtenerCategoriasUcProvider = Provider<ObtenerCategoriasUc>((ref) {
  return ObtenerCategoriasUc(ref.watch(categoriaRepositoryProvider));
});

final crearCategoriaUcProvider = Provider<CrearCategoriaUc>((ref) {
  return CrearCategoriaUc(ref.watch(categoriaRepositoryProvider));
});

final actualizarCategoriaUcProvider = Provider<ActualizarCategoriaUc>((ref) {
  return ActualizarCategoriaUc(ref.watch(categoriaRepositoryProvider));
});

final eliminarCategoriaUcProvider = Provider<EliminarCategoriaUc>((ref) {
  return EliminarCategoriaUc(ref.watch(categoriaRepositoryProvider));
});

final obtenerCategoriaPorIdUcProvider = Provider<ObtenerCategoriaPorIdUc>((ref) {
  return ObtenerCategoriaPorIdUc(ref.watch(categoriaRepositoryProvider));
});

final categoriaDetalleProvider = FutureProvider.family<CategoriaProducto?, int>((ref, id) {
  return ref.watch(obtenerCategoriaPorIdUcProvider)(id);
});
