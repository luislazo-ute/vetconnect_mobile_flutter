import '../../data/dtos/pagina_dto.dart';
import '../entities/hospitalizacion.dart';
import '../repositories/i_hospitalizacion_repository.dart';

class ObtenerHospitalizacionesUc {
  final IHospitalizacionRepository _repo;
  ObtenerHospitalizacionesUc(this._repo);

  Future<PaginaDto<Hospitalizacion>> call({int pagina = 1, String busqueda = ''}) {
    return _repo.obtenerHospitalizaciones(pagina: pagina, busqueda: busqueda);
  }
}
