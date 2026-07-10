import '../entities/vacuna.dart';
import '../repositories/i_vacuna_repository.dart';

class ObtenerVacunaPorIdUc {
  final IVacunaRepository _repo;
  ObtenerVacunaPorIdUc(this._repo);

  Future<Vacuna> call(int id) => _repo.obtenerVacuna(id);
}
