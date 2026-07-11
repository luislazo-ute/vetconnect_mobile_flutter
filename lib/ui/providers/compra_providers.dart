import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/compra_repository_impl.dart';
import '../../domain/entities/compra.dart';
import '../../domain/repositories/i_compra_repository.dart';
import '../../domain/usecases/crear_compra_uc.dart';
import '../../domain/usecases/eliminar_compra_uc.dart';
import '../../domain/usecases/obtener_compra_uc.dart';
import '../../domain/usecases/obtener_compras_uc.dart';
import 'cliente_autenticado_provider.dart';

final compraRepositoryProvider = Provider<ICompraRepository>((ref) {
  return CompraRepositoryImpl(ref.watch(clienteAutenticadoProvider));
});

final obtenerComprasUcProvider = Provider<ObtenerComprasUc>((ref) {
  return ObtenerComprasUc(ref.watch(compraRepositoryProvider));
});

final obtenerCompraUcProvider = Provider<ObtenerCompraUc>((ref) {
  return ObtenerCompraUc(ref.watch(compraRepositoryProvider));
});

final crearCompraUcProvider = Provider<CrearCompraUc>((ref) {
  return CrearCompraUc(ref.watch(compraRepositoryProvider));
});

final eliminarCompraUcProvider = Provider<EliminarCompraUc>((ref) {
  return EliminarCompraUc(ref.watch(compraRepositoryProvider));
});

final compraDetalleProvider = FutureProvider.family<Compra, int>((ref, id) {
  return ref.watch(obtenerCompraUcProvider)(id);
});
