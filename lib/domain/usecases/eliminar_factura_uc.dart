import '../repositories/i_factura_repository.dart';

class EliminarFacturaUc {
  final IFacturaRepository _repo;
  EliminarFacturaUc(this._repo);

  Future<void> call(int id) => _repo.eliminarFactura(id);
}
