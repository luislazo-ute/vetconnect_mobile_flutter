import '../entities/factura.dart';
import '../repositories/i_factura_repository.dart';

class ObtenerFacturaUc {
  final IFacturaRepository _repo;
  ObtenerFacturaUc(this._repo);

  Future<Factura> call(int id) => _repo.obtenerFactura(id);
}
