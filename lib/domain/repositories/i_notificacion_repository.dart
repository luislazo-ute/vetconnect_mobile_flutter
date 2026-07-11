import '../../data/dtos/pagina_dto.dart';
import '../entities/notificacion.dart';

abstract interface class INotificacionRepository {
  Future<PaginaDto<Notificacion>> obtenerNotificaciones({
    int pagina = 1,
    String busqueda = '',
  });
  Future<void> marcarComoLeida(int id);
  Future<void> marcarTodasComoLeidas();
}
