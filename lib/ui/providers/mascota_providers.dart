import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/mascota_repository_impl.dart';
import '../../domain/repositories/i_mascota_repository.dart';
import '../../domain/usecases/actualizar_mascota_uc.dart';
import '../../domain/usecases/crear_mascota_uc.dart';
import '../../domain/usecases/eliminar_mascota_uc.dart';
import '../../domain/usecases/obtener_mascotas_uc.dart';
import 'cliente_autenticado_provider.dart';

final mascotaRepositoryProvider = Provider<IMascotaRepository>((ref) {
  final cliente = ref.watch(clienteAutenticadoProvider);
  return MascotaRepositoryImpl(cliente);
});

final obtenerMascotasUcProvider = Provider(
  (ref) => ObtenerMascotasUc(ref.watch(mascotaRepositoryProvider)),
);
final crearMascotaUcProvider = Provider(
  (ref) => CrearMascotaUc(ref.watch(mascotaRepositoryProvider)),
);
final actualizarMascotaUcProvider = Provider(
  (ref) => ActualizarMascotaUc(ref.watch(mascotaRepositoryProvider)),
);
final eliminarMascotaUcProvider = Provider(
  (ref) => EliminarMascotaUc(ref.watch(mascotaRepositoryProvider)),
);
