import '../repositories/i_mascota_repository.dart';

class CrearMascotaUc {
  final IMascotaRepository _repo;
  CrearMascotaUc(this._repo);

  Future<void> call(Map<String, dynamic> datos) => _repo.crearMascota(datos);
}
