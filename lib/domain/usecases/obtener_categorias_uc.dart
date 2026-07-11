import '../entities/categoria_producto.dart';
import '../repositories/i_categoria_producto_repository.dart';

class ObtenerCategoriasUc {
  final ICategoriaProductoRepository _repo;
  ObtenerCategoriasUc(this._repo);

  Future<({List<CategoriaProducto> items, bool hayMas})> call({int pagina = 1, String busqueda = ''}) {
    return _repo.obtenerCategorias(pagina: pagina, busqueda: busqueda);
  }
}
