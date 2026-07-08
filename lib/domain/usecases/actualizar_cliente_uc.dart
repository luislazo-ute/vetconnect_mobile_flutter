import '../repositories/i_cliente_repository.dart';

class ActualizarClienteUc {
  final IClienteRepository _repo;
  ActualizarClienteUc(this._repo);

  Future<void> call(int id, Map<String, dynamic> datos) =>
      _repo.actualizarCliente(id, datos);
}
