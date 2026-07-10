import '../repositories/i_vacuna_repository.dart';

class EliminarVacunaUc {
  final IVacunaRepository _repo;
  EliminarVacunaUc(this._repo);

  Future<void> call(int id) => _repo.eliminarVacuna(id);
}
