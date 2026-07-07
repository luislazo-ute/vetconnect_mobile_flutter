import '../repositories/i_cita_repository.dart';

class CambiarEstadoCitaUc {
  final ICitaRepository _repo;
  CambiarEstadoCitaUc(this._repo);

  Future<void> call(int id, String estado) => _repo.cambiarEstado(id, estado);
}
