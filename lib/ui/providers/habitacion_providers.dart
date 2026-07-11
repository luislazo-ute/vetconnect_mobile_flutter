import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/habitacion_repository_impl.dart';
import '../../domain/repositories/i_habitacion_repository.dart';
import '../../domain/usecases/actualizar_habitacion_uc.dart';
import '../../domain/usecases/crear_habitacion_uc.dart';
import '../../domain/usecases/eliminar_habitacion_uc.dart';
import '../../domain/usecases/obtener_habitacion_por_id_uc.dart';
import '../../domain/usecases/obtener_habitaciones_uc.dart';
import 'cliente_autenticado_provider.dart';

final habitacionRepositoryProvider = Provider<IHabitacionRepository>((ref) {
  return HabitacionRepositoryImpl(ref.watch(clienteAutenticadoProvider));
});

final obtenerHabitacionesUcProvider = Provider(
  (ref) => ObtenerHabitacionesUc(ref.watch(habitacionRepositoryProvider)),
);
final crearHabitacionUcProvider = Provider(
  (ref) => CrearHabitacionUc(ref.watch(habitacionRepositoryProvider)),
);
final actualizarHabitacionUcProvider = Provider(
  (ref) => ActualizarHabitacionUc(ref.watch(habitacionRepositoryProvider)),
);
final eliminarHabitacionUcProvider = Provider(
  (ref) => EliminarHabitacionUc(ref.watch(habitacionRepositoryProvider)),
);
final obtenerHabitacionPorIdUcProvider = Provider(
  (ref) => ObtenerHabitacionPorIdUc(ref.watch(habitacionRepositoryProvider)),
);
