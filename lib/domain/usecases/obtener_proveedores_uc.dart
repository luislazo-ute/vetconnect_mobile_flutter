import '../entities/proveedor.dart';
import '../repositories/i_proveedor_repository.dart';

class ObtenerProveedoresUc {
  final IProveedorRepository _repo;
  ObtenerProveedoresUc(this._repo);

  Future<({List<Proveedor> items, bool hayMas})> call({int pagina = 1, String busqueda = ''}) {
    return _repo.obtenerProveedores(pagina: pagina, busqueda: busqueda);
  }
}
