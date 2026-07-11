import '../entities/factura.dart';
import '../repositories/i_factura_repository.dart';

class ObtenerFacturasUc {
  final IFacturaRepository _repo;
  ObtenerFacturasUc(this._repo);

  Future<({List<Factura> items, bool hayMas})> call({int pagina = 1}) {
    return _repo.obtenerFacturas(pagina: pagina);
  }
}
