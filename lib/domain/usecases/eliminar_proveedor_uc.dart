import '../repositories/i_proveedor_repository.dart';

class EliminarProveedorUc {
  final IProveedorRepository _repo;
  EliminarProveedorUc(this._repo);

  Future<void> call(int id) => _repo.eliminarProveedor(id);
}
