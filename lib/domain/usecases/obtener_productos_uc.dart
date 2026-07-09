import '../entities/producto.dart';
import '../repositories/i_producto_repository.dart';

class ObtenerProductosUc {
  final IProductoRepository _repo;
  ObtenerProductosUc(this._repo);

  Future<({List<Producto> items, bool hayMas})> call({int pagina = 1, String busqueda = ''}) {
    return _repo.obtenerProductos(pagina: pagina, busqueda: busqueda);
  }
}
