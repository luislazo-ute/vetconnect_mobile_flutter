import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/veterinario_repository_impl.dart';
import '../../domain/repositories/i_veterinario_repository.dart';
import '../../domain/usecases/obtener_veterinarios_uc.dart';
import 'http_provider.dart';

/// Provider del repositorio de veterinarios (expuesto como INTERFAZ).
final veterinarioRepositoryProvider = Provider<IVeterinarioRepository>((ref) {
  final cliente = ref.watch(httpClientProvider);
  return VeterinarioRepositoryImpl(cliente);
});

/// Provider del use case, que depende del repositorio anterior.
final obtenerVeterinariosUcProvider = Provider<ObtenerVeterinariosUc>((ref) {
  final repo = ref.watch(veterinarioRepositoryProvider);
  return ObtenerVeterinariosUc(repo);
});
