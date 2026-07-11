import '../entities/categoria_producto.dart';
import '../repositories/i_categoria_producto_repository.dart';

class ObtenerCategoriaPorIdUc {
  final ICategoriaProductoRepository _repo;
  ObtenerCategoriaPorIdUc(this._repo);

  Future<CategoriaProducto> call(int id) => _repo.obtenerCategoria(id);
}
