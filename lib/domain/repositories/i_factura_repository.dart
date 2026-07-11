import '../entities/factura.dart';

abstract interface class IFacturaRepository {
  Future<({List<Factura> items, bool hayMas})> obtenerFacturas({int pagina = 1});
  Future<Factura> obtenerFactura(int id);
  Future<Factura> crearFactura({
    required Map<String, dynamic> datos,
    required List<Map<String, dynamic>> detalles,
  });
  Future<void> registrarPago(Map<String, dynamic> datos);
  Future<void> eliminarFactura(int id);
}
