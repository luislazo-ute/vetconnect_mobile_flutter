import '../entities/producto.dart';
import '../repositories/i_producto_repository.dart';

class ActualizarProductoUc {
  final IProductoRepository _repo;
  ActualizarProductoUc(this._repo);

  Future<Producto> call(int id, Map<String, dynamic> datos) =>
      _repo.actualizarProducto(id, datos);
}
