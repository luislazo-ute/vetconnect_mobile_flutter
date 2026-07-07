import '../repositories/i_mascota_repository.dart';

class EliminarMascotaUc {
  final IMascotaRepository _repo;
  EliminarMascotaUc(this._repo);

  Future<void> call(int id) => _repo.eliminarMascota(id);
}
