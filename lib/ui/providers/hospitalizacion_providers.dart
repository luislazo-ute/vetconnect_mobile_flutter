import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/hospitalizacion_repository_impl.dart';
import '../../domain/repositories/i_hospitalizacion_repository.dart';
import '../../domain/usecases/actualizar_hospitalizacion_uc.dart';
import '../../domain/usecases/crear_hospitalizacion_uc.dart';
import '../../domain/usecases/eliminar_hospitalizacion_uc.dart';
import '../../domain/usecases/obtener_hospitalizacion_por_id_uc.dart';
import '../../domain/usecases/obtener_hospitalizaciones_uc.dart';
import 'cliente_autenticado_provider.dart';

final hospitalizacionRepositoryProvider = Provider<IHospitalizacionRepository>((ref) {
  return HospitalizacionRepositoryImpl(ref.watch(clienteAutenticadoProvider));
});

final obtenerHospitalizacionesUcProvider = Provider(
  (ref) => ObtenerHospitalizacionesUc(ref.watch(hospitalizacionRepositoryProvider)),
);
final crearHospitalizacionUcProvider = Provider(
  (ref) => CrearHospitalizacionUc(ref.watch(hospitalizacionRepositoryProvider)),
);
final actualizarHospitalizacionUcProvider = Provider(
  (ref) => ActualizarHospitalizacionUc(ref.watch(hospitalizacionRepositoryProvider)),
);
final eliminarHospitalizacionUcProvider = Provider(
  (ref) => EliminarHospitalizacionUc(ref.watch(hospitalizacionRepositoryProvider)),
);
final obtenerHospitalizacionPorIdUcProvider = Provider(
  (ref) => ObtenerHospitalizacionPorIdUc(ref.watch(hospitalizacionRepositoryProvider)),
);
