import '../entities/cliente.dart';

/// Contrato del repositorio de clientes.
abstract interface class IClienteRepository {
  /// Devuelve todos los clientes (para selectores y gestión).
  Future<List<Cliente>> obtenerClientes();

  /// Edita teléfono/dirección de un cliente (ADMIN).
  Future<void> actualizarCliente(int id, Map<String, dynamic> datos);

  /// Elimina un cliente (ADMIN).
  Future<void> eliminarCliente(int id);
}
