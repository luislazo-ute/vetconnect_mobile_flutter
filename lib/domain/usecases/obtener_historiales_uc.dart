import '../../data/dtos/pagina_dto.dart';
import '../entities/historial.dart';
import '../repositories/i_historial_repository.dart';

class ObtenerHistorialesUc {
  final IHistorialRepository _repo;
  ObtenerHistorialesUc(this._repo);

  Future<PaginaDto<Historial>> call({int pagina = 1, String busqueda = ''}) =>
      _repo.obtenerHistoriales(pagina: pagina, busqueda: busqueda);
}
