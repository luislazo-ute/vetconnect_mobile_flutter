import '../entities/cliente.dart';

abstract interface class IClienteRepository {
  Future<List<Cliente>> obtenerClientes();

  Future<void> actualizarCliente(int id, Map<String, dynamic> datos);

  Future<void> eliminarCliente(int id);
}
