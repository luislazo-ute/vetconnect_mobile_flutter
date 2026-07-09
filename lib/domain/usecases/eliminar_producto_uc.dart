import '../repositories/i_producto_repository.dart';

class EliminarProductoUc {
  final IProductoRepository _repo;
  EliminarProductoUc(this._repo);

  Future<void> call(int id) => _repo.eliminarProducto(id);
}
