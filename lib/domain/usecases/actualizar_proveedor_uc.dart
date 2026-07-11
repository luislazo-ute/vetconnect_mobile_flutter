import '../entities/proveedor.dart';
import '../repositories/i_proveedor_repository.dart';

class ActualizarProveedorUc {
  final IProveedorRepository _repo;
  ActualizarProveedorUc(this._repo);

  Future<Proveedor> call(int id, Map<String, dynamic> datos) =>
      _repo.actualizarProveedor(id, datos);
}
