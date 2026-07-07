import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../data/almacenamiento_tokens.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/i_auth_repository.dart';
import '../../domain/usecases/cerrar_sesion_uc.dart';
import '../../domain/usecases/iniciar_sesion_uc.dart';
import '../../domain/usecases/obtener_perfil_uc.dart';
import '../../domain/usecases/refrescar_token_uc.dart';
import 'http_provider.dart';

/// Almacenamiento seguro de tokens (caja fuerte compartida).
final almacenamientoTokensProvider = Provider<AlmacenamientoTokens>((ref) {
  return AlmacenamientoTokens(const FlutterSecureStorage());
});

/// Repositorio de auth, expuesto como INTERFAZ.
final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  final cliente = ref.watch(httpClientProvider);
  final almacenamiento = ref.watch(almacenamientoTokensProvider);
  return AuthRepositoryImpl(cliente, almacenamiento);
});

// --- Use cases ---
final iniciarSesionUcProvider =
    Provider((ref) => IniciarSesionUc(ref.watch(authRepositoryProvider)));
final cerrarSesionUcProvider =
    Provider((ref) => CerrarSesionUc(ref.watch(authRepositoryProvider)));
final refrescarTokenUcProvider =
    Provider((ref) => RefrescarTokenUc(ref.watch(authRepositoryProvider)));
final obtenerPerfilUcProvider =
    Provider((ref) => ObtenerPerfilUc(ref.watch(authRepositoryProvider)));
