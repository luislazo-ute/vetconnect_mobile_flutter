import '../entities/categoria_producto.dart';

abstract interface class ICategoriaProductoRepository {
  Future<({List<CategoriaProducto> items, bool hayMas})> obtenerCategorias({
    int pagina = 1,
    String busqueda = '',
  });
  Future<CategoriaProducto> obtenerCategoria(int id);
  Future<CategoriaProducto> crearCategoria(Map<String, dynamic> datos);
  Future<CategoriaProducto> actualizarCategoria(int id, Map<String, dynamic> datos);
  Future<void> eliminarCategoria(int id);
}
