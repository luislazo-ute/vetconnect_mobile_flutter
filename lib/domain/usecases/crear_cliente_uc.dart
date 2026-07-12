import '../repositories/i_cliente_repository.dart';

class CrearClienteUc {
  final IClienteRepository _repo;
  CrearClienteUc(this._repo);

  Future<void> call(Map<String, dynamic> datos) => _repo.crearCliente(datos);
}
