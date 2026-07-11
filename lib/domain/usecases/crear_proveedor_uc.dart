import '../entities/proveedor.dart';
import '../repositories/i_proveedor_repository.dart';

class CrearProveedorUc {
  final IProveedorRepository _repo;
  CrearProveedorUc(this._repo);

  Future<Proveedor> call(Map<String, dynamic> datos) => _repo.crearProveedor(datos);
}
