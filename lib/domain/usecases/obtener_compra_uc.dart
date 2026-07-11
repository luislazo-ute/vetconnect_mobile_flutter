import '../entities/compra.dart';
import '../repositories/i_compra_repository.dart';

class ObtenerCompraUc {
  final ICompraRepository _repo;
  ObtenerCompraUc(this._repo);

  Future<Compra> call(int id) => _repo.obtenerCompra(id);
}
