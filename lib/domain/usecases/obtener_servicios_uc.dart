import '../../data/dtos/pagina_dto.dart';
import '../entities/servicio.dart';
import '../repositories/i_servicio_repository.dart';

class ObtenerServiciosUc {
  final IServicioRepository _repo;

  ObtenerServiciosUc(this._repo);

  Future<PaginaDto<Servicio>> call({int pagina = 1, String busqueda = ''}) {
    return _repo.obtenerServicios(pagina: pagina, busqueda: busqueda);
  }
}
