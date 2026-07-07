import '../repositories/i_mascota_repository.dart';

class ActualizarMascotaUc {
  final IMascotaRepository _repo;
  ActualizarMascotaUc(this._repo);

  Future<void> call(int id, Map<String, dynamic> datos) =>
      _repo.actualizarMascota(id, datos);
}
