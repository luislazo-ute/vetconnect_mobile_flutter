import '../entities/hospitalizacion.dart';
import '../repositories/i_hospitalizacion_repository.dart';

class CrearHospitalizacionUc {
  final IHospitalizacionRepository _repo;
  CrearHospitalizacionUc(this._repo);

  Future<Hospitalizacion> call(Map<String, dynamic> datos) =>
      _repo.crearHospitalizacion(datos);
}
