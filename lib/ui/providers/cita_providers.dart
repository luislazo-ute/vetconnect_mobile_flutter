import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/cita_repository_impl.dart';
import '../../domain/entities/mascota.dart';
import '../../domain/entities/veterinario.dart';
import '../../domain/repositories/i_cita_repository.dart';
import '../../domain/usecases/agendar_cita_uc.dart';
import '../../domain/usecases/cambiar_estado_cita_uc.dart';
import '../../domain/usecases/obtener_citas_uc.dart';
import 'cliente_autenticado_provider.dart';
import 'mascota_providers.dart';
import 'veterinario_providers.dart';

final citaRepositoryProvider = Provider<ICitaRepository>((ref) {
  return CitaRepositoryImpl(ref.watch(clienteAutenticadoProvider));
});

final obtenerCitasUcProvider = Provider(
  (ref) => ObtenerCitasUc(ref.watch(citaRepositoryProvider)),
);
final agendarCitaUcProvider = Provider(
  (ref) => AgendarCitaUc(ref.watch(citaRepositoryProvider)),
);
final cambiarEstadoCitaUcProvider = Provider(
  (ref) => CambiarEstadoCitaUc(ref.watch(citaRepositoryProvider)),
);

final mascotasTodasProvider = FutureProvider<List<Mascota>>((ref) async {
  final pagina = await ref.watch(obtenerMascotasUcProvider)(pagina: 1);
  return pagina.results;
});

final veterinariosTodosProvider = FutureProvider<List<Veterinario>>((
  ref,
) async {
  final pagina = await ref.watch(obtenerVeterinariosUcProvider)(pagina: 1);
  return pagina.results;
});
