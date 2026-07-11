import '../repositories/i_compra_repository.dart';

class EliminarCompraUc {
  final ICompraRepository _repo;
  EliminarCompraUc(this._repo);

  Future<void> call(int id) => _repo.eliminarCompra(id);
}
