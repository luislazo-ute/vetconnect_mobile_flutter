import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/vacuna_repository_impl.dart';
import '../../domain/repositories/i_vacuna_repository.dart';
import '../../domain/usecases/actualizar_vacuna_uc.dart';
import '../../domain/usecases/crear_vacuna_uc.dart';
import '../../domain/usecases/eliminar_vacuna_uc.dart';
import '../../domain/usecases/obtener_vacuna_por_id_uc.dart';
import '../../domain/usecases/obtener_vacunas_uc.dart';
import 'cliente_autenticado_provider.dart';

final vacunaRepositoryProvider = Provider<IVacunaRepository>((ref) {
  return VacunaRepositoryImpl(ref.watch(clienteAutenticadoProvider));
});

final obtenerVacunasUcProvider = Provider(
  (ref) => ObtenerVacunasUc(ref.watch(vacunaRepositoryProvider)),
);
final crearVacunaUcProvider = Provider(
  (ref) => CrearVacunaUc(ref.watch(vacunaRepositoryProvider)),
);
final actualizarVacunaUcProvider = Provider(
  (ref) => ActualizarVacunaUc(ref.watch(vacunaRepositoryProvider)),
);
final eliminarVacunaUcProvider = Provider(
  (ref) => EliminarVacunaUc(ref.watch(vacunaRepositoryProvider)),
);
final obtenerVacunaPorIdUcProvider = Provider(
  (ref) => ObtenerVacunaPorIdUc(ref.watch(vacunaRepositoryProvider)),
);
