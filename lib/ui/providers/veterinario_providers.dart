import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/veterinario_repository_impl.dart';
import '../../domain/repositories/i_veterinario_repository.dart';
import '../../domain/usecases/actualizar_veterinario_uc.dart';
import '../../domain/usecases/crear_veterinario_uc.dart';
import '../../domain/usecases/eliminar_veterinario_uc.dart';
import '../../domain/usecases/obtener_veterinarios_uc.dart';
import 'cliente_autenticado_provider.dart';
import 'http_provider.dart';

final veterinarioRepositoryProvider = Provider<IVeterinarioRepository>((ref) {
  return VeterinarioRepositoryImpl(ref.watch(httpClientProvider));
});

final obtenerVeterinariosUcProvider = Provider<ObtenerVeterinariosUc>((ref) {
  return ObtenerVeterinariosUc(ref.watch(veterinarioRepositoryProvider));
});

final veterinarioAdminRepositoryProvider = Provider<IVeterinarioRepository>((
  ref,
) {
  return VeterinarioRepositoryImpl(ref.watch(clienteAutenticadoProvider));
});

final crearVeterinarioUcProvider = Provider(
  (ref) => CrearVeterinarioUc(ref.watch(veterinarioAdminRepositoryProvider)),
);
final actualizarVeterinarioUcProvider = Provider(
  (ref) =>
      ActualizarVeterinarioUc(ref.watch(veterinarioAdminRepositoryProvider)),
);
final eliminarVeterinarioUcProvider = Provider(
  (ref) => EliminarVeterinarioUc(ref.watch(veterinarioAdminRepositoryProvider)),
);
