import '../repositories/i_cliente_repository.dart';

class EliminarClienteUc {
  final IClienteRepository _repo;
  EliminarClienteUc(this._repo);

  Future<void> call(int id) => _repo.eliminarCliente(id);
}
