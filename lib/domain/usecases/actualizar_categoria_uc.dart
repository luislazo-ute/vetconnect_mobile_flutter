import '../entities/categoria_producto.dart';
import '../repositories/i_categoria_producto_repository.dart';

class ActualizarCategoriaUc {
  final ICategoriaProductoRepository _repo;
  ActualizarCategoriaUc(this._repo);

  Future<CategoriaProducto> call(int id, Map<String, dynamic> datos) {
    return _repo.actualizarCategoria(id, datos);
  }
}
