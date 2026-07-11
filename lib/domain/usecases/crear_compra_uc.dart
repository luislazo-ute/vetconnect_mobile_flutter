import '../entities/compra.dart';
import '../repositories/i_compra_repository.dart';

class CrearCompraUc {
  final ICompraRepository _repo;
  CrearCompraUc(this._repo);

  Future<Compra> call({
    required Map<String, dynamic> datos,
    required List<Map<String, dynamic>> detalles,
  }) {
    return _repo.crearCompra(datos: datos, detalles: detalles);
  }
}
