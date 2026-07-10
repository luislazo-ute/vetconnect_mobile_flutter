import '../repositories/i_hospitalizacion_repository.dart';

class EliminarHospitalizacionUc {
  final IHospitalizacionRepository _repo;
  EliminarHospitalizacionUc(this._repo);

  Future<void> call(int id) => _repo.eliminarHospitalizacion(id);
}
