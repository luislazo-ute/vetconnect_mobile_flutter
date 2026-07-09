import '../entities/categoria_producto.dart';
import '../repositories/i_categoria_producto_repository.dart';

class CrearCategoriaUc {
  final ICategoriaProductoRepository _repo;
  CrearCategoriaUc(this._repo);

  Future<CategoriaProducto> call(Map<String, dynamic> datos) {
    return _repo.crearCategoria(datos);
  }
}
