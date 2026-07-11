import '../entities/hospitalizacion.dart';
import '../repositories/i_hospitalizacion_repository.dart';

class ActualizarHospitalizacionUc {
  final IHospitalizacionRepository _repo;
  ActualizarHospitalizacionUc(this._repo);

  Future<Hospitalizacion> call(int id, Map<String, dynamic> datos) =>
      _repo.actualizarHospitalizacion(id, datos);
}
