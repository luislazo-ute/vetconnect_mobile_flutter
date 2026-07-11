import '../../data/dtos/pagina_dto.dart';
import '../entities/notificacion.dart';
import '../repositories/i_notificacion_repository.dart';

class ObtenerNotificacionesUc {
  final INotificacionRepository _repo;
  ObtenerNotificacionesUc(this._repo);

  Future<PaginaDto<Notificacion>> call({int pagina = 1, String busqueda = ''}) {
    return _repo.obtenerNotificaciones(pagina: pagina, busqueda: busqueda);
  }
}
