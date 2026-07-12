import '../entities/cliente.dart';

abstract interface class IClienteRepository {
  Future<List<Cliente>> obtenerClientes();

  /// Crea el perfil de cliente. Requiere el id del usuario ya creado
  /// (Cliente.user es obligatorio en el backend).
  Future<void> crearCliente(Map<String, dynamic> datos);

  Future<void> actualizarCliente(int id, Map<String, dynamic> datos);

  Future<void> eliminarCliente(int id);
}
