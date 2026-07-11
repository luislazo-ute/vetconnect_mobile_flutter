import '../repositories/i_factura_repository.dart';

class RegistrarPagoUc {
  final IFacturaRepository _repo;
  RegistrarPagoUc(this._repo);

  Future<void> call(Map<String, dynamic> datos) => _repo.registrarPago(datos);
}
