import '../entities/producto.dart';
import '../repositories/i_producto_repository.dart';

class CrearProductoUc {
  final IProductoRepository _repo;
  CrearProductoUc(this._repo);

  Future<Producto> call(Map<String, dynamic> datos) => _repo.crearProducto(datos);
}
