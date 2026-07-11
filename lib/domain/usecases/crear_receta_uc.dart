import '../entities/receta.dart';
import '../repositories/i_receta_repository.dart';

class CrearRecetaUc {
  final IRecetaRepository _repo;
  CrearRecetaUc(this._repo);

  Future<Receta> call({
    required Map<String, dynamic> datos,
    required List<Map<String, dynamic>> detalles,
  }) {
    return _repo.crearReceta(datos: datos, detalles: detalles);
  }
}
