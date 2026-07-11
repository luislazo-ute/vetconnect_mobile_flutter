import '../entities/proveedor.dart';

abstract interface class IProveedorRepository {
  Future<({List<Proveedor> items, bool hayMas})> obtenerProveedores({
    int pagina = 1,
    String busqueda = '',
  });
  Future<Proveedor> crearProveedor(Map<String, dynamic> datos);
  Future<Proveedor> actualizarProveedor(int id, Map<String, dynamic> datos);
  Future<void> eliminarProveedor(int id);
}
