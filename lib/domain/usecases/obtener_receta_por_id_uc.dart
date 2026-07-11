import '../entities/receta.dart';
import '../repositories/i_receta_repository.dart';

class ObtenerRecetaPorIdUc {
  final IRecetaRepository _repo;
  ObtenerRecetaPorIdUc(this._repo);

  Future<Receta> call(int id) => _repo.obtenerReceta(id);
}
