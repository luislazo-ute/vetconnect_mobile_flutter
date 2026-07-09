import '../repositories/i_servicio_repository_ext.dart';

class EliminarServicioUc {
  final IServicioAdminRepository _repo;
  EliminarServicioUc(this._repo);

  Future<void> call(int id) => _repo.eliminarServicio(id);
}
