import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/cliente_repository_impl.dart';
import '../../data/repositories/usuario_admin_repository_impl.dart';
import '../../domain/entities/cliente.dart';
import '../../domain/repositories/i_cliente_repository.dart';
import '../../domain/repositories/i_usuario_admin_repository.dart';
import '../../domain/usecases/actualizar_cliente_uc.dart';
import '../../domain/usecases/crear_cliente_uc.dart';
import '../../domain/usecases/crear_usuario_uc.dart';
import '../../domain/usecases/eliminar_cliente_uc.dart';
import 'cliente_autenticado_provider.dart';

final clienteRepositoryProvider = Provider<IClienteRepository>((ref) {
  return ClienteRepositoryImpl(ref.watch(clienteAutenticadoProvider));
});

final clientesProvider = FutureProvider<List<Cliente>>((ref) {
  return ref.watch(clienteRepositoryProvider).obtenerClientes();
});

final actualizarClienteUcProvider = Provider(
  (ref) => ActualizarClienteUc(ref.watch(clienteRepositoryProvider)),
);
final eliminarClienteUcProvider = Provider(
  (ref) => EliminarClienteUc(ref.watch(clienteRepositoryProvider)),
);
final crearClienteUcProvider = Provider(
  (ref) => CrearClienteUc(ref.watch(clienteRepositoryProvider)),
);

// --- Cuentas de usuario (solo admin) ---
final usuarioAdminRepositoryProvider = Provider<IUsuarioAdminRepository>((ref) {
  return UsuarioAdminRepositoryImpl(ref.watch(clienteAutenticadoProvider));
});

final crearUsuarioUcProvider = Provider(
  (ref) => CrearUsuarioUc(ref.watch(usuarioAdminRepositoryProvider)),
);
