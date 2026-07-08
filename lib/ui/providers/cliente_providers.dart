import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/cliente_repository_impl.dart';
import '../../domain/entities/cliente.dart';
import '../../domain/repositories/i_cliente_repository.dart';
import '../../domain/usecases/actualizar_cliente_uc.dart';
import '../../domain/usecases/eliminar_cliente_uc.dart';
import 'cliente_autenticado_provider.dart';

final clienteRepositoryProvider = Provider<IClienteRepository>((ref) {
  return ClienteRepositoryImpl(ref.watch(clienteAutenticadoProvider));
});

/// FutureProvider: expone la lista de clientes de forma asíncrona.
/// La UI la lee con .when(data/loading/error). Perfecto para dropdowns y gestión.
final clientesProvider = FutureProvider<List<Cliente>>((ref) {
  return ref.watch(clienteRepositoryProvider).obtenerClientes();
});

final actualizarClienteUcProvider =
    Provider((ref) => ActualizarClienteUc(ref.watch(clienteRepositoryProvider)));
final eliminarClienteUcProvider =
    Provider((ref) => EliminarClienteUc(ref.watch(clienteRepositoryProvider)));
