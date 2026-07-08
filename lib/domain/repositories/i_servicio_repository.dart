import '../../data/dtos/pagina_dto.dart';
import '../entities/servicio.dart';

abstract interface class IServicioRepository {
  Future<PaginaDto<Servicio>> obtenerServicios({
    int pagina = 1,
    String busqueda = '',
  });
}
