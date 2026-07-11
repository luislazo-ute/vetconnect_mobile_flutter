import '../entities/vacuna.dart';
import '../repositories/i_vacuna_repository.dart';

class ActualizarVacunaUc {
  final IVacunaRepository _repo;
  ActualizarVacunaUc(this._repo);

  Future<Vacuna> call(int id, Map<String, dynamic> datos) =>
      _repo.actualizarVacuna(id, datos);
}
