import '../../data/dtos/pagina_dto.dart';
import '../entities/receta.dart';
import '../repositories/i_receta_repository.dart';

class ObtenerRecetasUc {
  final IRecetaRepository _repo;
  ObtenerRecetasUc(this._repo);

  Future<PaginaDto<Receta>> call({int pagina = 1, String busqueda = ''}) {
    return _repo.obtenerRecetas(pagina: pagina, busqueda: busqueda);
  }
}
