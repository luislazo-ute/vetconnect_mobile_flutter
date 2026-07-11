import '../entities/compra.dart';

abstract interface class ICompraRepository {
  Future<({List<Compra> items, bool hayMas})> obtenerCompras({int pagina = 1});
  Future<Compra> obtenerCompra(int id);
  Future<Compra> crearCompra({
    required Map<String, dynamic> datos,
    required List<Map<String, dynamic>> detalles,
  });
  Future<void> eliminarCompra(int id);
}
