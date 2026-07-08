import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/historial_repository_impl.dart';
import '../../domain/repositories/i_historial_repository.dart';
import '../../domain/usecases/actualizar_historial_uc.dart';
import '../../domain/usecases/crear_historial_uc.dart';
import '../../domain/usecases/obtener_historiales_uc.dart';
import 'cliente_autenticado_provider.dart';

final historialRepositoryProvider = Provider<IHistorialRepository>((ref) {
  return HistorialRepositoryImpl(ref.watch(clienteAutenticadoProvider));
});

final obtenerHistorialesUcProvider = Provider(
  (ref) => ObtenerHistorialesUc(ref.watch(historialRepositoryProvider)),
);
final crearHistorialUcProvider = Provider(
  (ref) => CrearHistorialUc(ref.watch(historialRepositoryProvider)),
);
final actualizarHistorialUcProvider = Provider(
  (ref) => ActualizarHistorialUc(ref.watch(historialRepositoryProvider)),
);
