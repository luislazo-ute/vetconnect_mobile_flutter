import '../entities/factura.dart';
import '../repositories/i_factura_repository.dart';

class CrearFacturaUc {
  final IFacturaRepository _repo;
  CrearFacturaUc(this._repo);

  Future<Factura> call({
    required Map<String, dynamic> datos,
    required List<Map<String, dynamic>> detalles,
  }) {
    return _repo.crearFactura(datos: datos, detalles: detalles);
  }
}
