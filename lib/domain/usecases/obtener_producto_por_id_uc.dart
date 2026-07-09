import '../entities/producto.dart';
import '../repositories/i_producto_repository.dart';

class ObtenerProductoPorIdUc {
  final IProductoRepository _repo;
  ObtenerProductoPorIdUc(this._repo);

  Future<Producto> call(int id) => _repo.obtenerProducto(id);
}
