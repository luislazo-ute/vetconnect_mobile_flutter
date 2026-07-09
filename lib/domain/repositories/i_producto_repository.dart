import '../entities/producto.dart';

abstract interface class IProductoRepository {
  Future<({List<Producto> items, bool hayMas})> obtenerProductos({
    int pagina = 1,
    String busqueda = '',
  });
  Future<Producto> obtenerProducto(int id);
  Future<Producto> crearProducto(Map<String, dynamic> datos);
  Future<Producto> actualizarProducto(int id, Map<String, dynamic> datos);
  Future<void> eliminarProducto(int id);
}
