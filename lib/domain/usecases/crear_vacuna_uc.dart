import '../entities/vacuna.dart';
import '../repositories/i_vacuna_repository.dart';

class CrearVacunaUc {
  final IVacunaRepository _repo;
  CrearVacunaUc(this._repo);

  Future<Vacuna> call(Map<String, dynamic> datos) => _repo.crearVacuna(datos);
}
