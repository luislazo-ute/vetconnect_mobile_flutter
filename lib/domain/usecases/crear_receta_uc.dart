import '../entities/receta.dart';
import '../repositories/i_receta_repository.dart';

class CrearRecetaUc {
  final IRecetaRepository _repo;
  CrearRecetaUc(this._repo);

  Future<Receta> call(Map<String, dynamic> datos) => _repo.crearReceta(datos);
}
