import '../repositories/i_cita_repository.dart';

class AgendarCitaUc {
  final ICitaRepository _repo;
  AgendarCitaUc(this._repo);

  Future<void> call(Map<String, dynamic> datos) => _repo.agendarCita(datos);
}
