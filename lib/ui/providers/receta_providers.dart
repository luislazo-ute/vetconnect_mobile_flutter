import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/receta_repository_impl.dart';
import '../../domain/entities/receta.dart';
import '../../domain/repositories/i_receta_repository.dart';
import '../../domain/usecases/actualizar_receta_uc.dart';
import '../../domain/usecases/crear_receta_uc.dart';
import '../../domain/usecases/eliminar_receta_uc.dart';
import '../../domain/usecases/obtener_receta_por_id_uc.dart';
import '../../domain/usecases/obtener_recetas_uc.dart';
import 'cliente_autenticado_provider.dart';

final recetaRepositoryProvider = Provider<IRecetaRepository>((ref) {
  return RecetaRepositoryImpl(ref.watch(clienteAutenticadoProvider));
});

final obtenerRecetasUcProvider = Provider(
  (ref) => ObtenerRecetasUc(ref.watch(recetaRepositoryProvider)),
);
final crearRecetaUcProvider = Provider(
  (ref) => CrearRecetaUc(ref.watch(recetaRepositoryProvider)),
);
final actualizarRecetaUcProvider = Provider(
  (ref) => ActualizarRecetaUc(ref.watch(recetaRepositoryProvider)),
);
final eliminarRecetaUcProvider = Provider(
  (ref) => EliminarRecetaUc(ref.watch(recetaRepositoryProvider)),
);
final obtenerRecetaPorIdUcProvider = Provider(
  (ref) => ObtenerRecetaPorIdUc(ref.watch(recetaRepositoryProvider)),
);

final recetaDetalleProvider = FutureProvider.family<Receta, int>((ref, id) {
  return ref.watch(obtenerRecetaPorIdUcProvider)(id);
});
