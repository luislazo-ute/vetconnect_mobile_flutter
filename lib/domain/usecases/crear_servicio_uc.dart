import '../entities/servicio.dart';
import '../repositories/i_servicio_repository_ext.dart';

class CrearServicioUc {
  final IServicioAdminRepository _repo;
  CrearServicioUc(this._repo);

  Future<Servicio> call(Map<String, dynamic> datos) => _repo.crearServicio(datos);
}
