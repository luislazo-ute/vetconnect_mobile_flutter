import '../entities/cliente.dart';

/// Contrato del repositorio de clientes.
abstract interface class IClienteRepository {
  /// Devuelve todos los clientes (para selectores/dropdowns).
  Future<List<Cliente>> obtenerClientes();
}
