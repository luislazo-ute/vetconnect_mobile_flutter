import '../entities/servicio.dart';
import '../repositories/i_servicio_repository_ext.dart';

class ActualizarServicioUc {
  final IServicioAdminRepository _repo;
  ActualizarServicioUc(this._repo);

  Future<Servicio> call(int id, Map<String, dynamic> datos) =>
      _repo.actualizarServicio(id, datos);
}
