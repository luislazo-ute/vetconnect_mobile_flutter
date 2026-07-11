import '../entities/compra.dart';
import '../repositories/i_compra_repository.dart';

class ObtenerComprasUc {
  final ICompraRepository _repo;
  ObtenerComprasUc(this._repo);

  Future<({List<Compra> items, bool hayMas})> call({int pagina = 1}) {
    return _repo.obtenerCompras(pagina: pagina);
  }
}
