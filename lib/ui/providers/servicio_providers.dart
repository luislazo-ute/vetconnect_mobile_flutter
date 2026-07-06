import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/servicio_repository_impl.dart';
import '../../domain/repositories/i_servicio_repository.dart';
import '../../domain/usecases/obtener_servicios_uc.dart';
import 'http_provider.dart';

/// Provider del repositorio de servicios.
/// TIPO = la interfaz; así los consumidores dependen de la abstracción,
/// no de la implementación concreta.
final servicioRepositoryProvider = Provider<IServicioRepository>((ref) {
  final cliente = ref.watch(httpClientProvider); // reutiliza el cliente http
  return ServicioRepositoryImpl(cliente);
});

/// Provider del use case, que depende del repositorio anterior.
final obtenerServiciosUcProvider = Provider<ObtenerServiciosUc>((ref) {
  final repo = ref.watch(servicioRepositoryProvider);
  // COMPLETAR: construir el use case con el repo.
  // Pista: return ObtenerServiciosUc(repo);
  return ObtenerServiciosUc(repo);
});
