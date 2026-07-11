import '../repositories/i_receta_repository.dart';

class EliminarRecetaUc {
  final IRecetaRepository _repo;
  EliminarRecetaUc(this._repo);

  Future<void> call(int id) => _repo.eliminarReceta(id);
}
