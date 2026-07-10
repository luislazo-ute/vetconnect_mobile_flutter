import '../entities/receta.dart';
import '../repositories/i_receta_repository.dart';

class ActualizarRecetaUc {
  final IRecetaRepository _repo;
  ActualizarRecetaUc(this._repo);

  Future<Receta> call(int id, Map<String, dynamic> datos) =>
      _repo.actualizarReceta(id, datos);
}
