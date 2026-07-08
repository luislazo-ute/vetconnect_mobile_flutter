import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/servicio_repository_impl.dart';
import '../../domain/repositories/i_servicio_repository.dart';
import '../../domain/usecases/obtener_servicios_uc.dart';
import 'http_provider.dart';

final servicioRepositoryProvider = Provider<IServicioRepository>((ref) {
  final cliente = ref.watch(httpClientProvider);
  return ServicioRepositoryImpl(cliente);
});

final obtenerServiciosUcProvider = Provider<ObtenerServiciosUc>((ref) {
  final repo = ref.watch(servicioRepositoryProvider);
  return ObtenerServiciosUc(repo);
});
