import '../entities/hospitalizacion.dart';
import '../repositories/i_hospitalizacion_repository.dart';

class ObtenerHospitalizacionPorIdUc {
  final IHospitalizacionRepository _repo;
  ObtenerHospitalizacionPorIdUc(this._repo);

  Future<Hospitalizacion> call(int id) => _repo.obtenerHospitalizacion(id);
}
