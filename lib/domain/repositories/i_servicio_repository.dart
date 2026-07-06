import '../../data/dtos/pagina_dto.dart';
import '../entities/servicio.dart';

/// Contrato del repositorio de servicios: define QUÉ operaciones existen,
/// no CÓMO se implementan. La capa data lo implementará.
abstract interface class IServicioRepository {
  /// Obtiene una página de servicios. `busqueda` filtra por nombre.
  Future<PaginaDto<Servicio>> obtenerServicios({
    int pagina = 1,
    String busqueda = '',
  });
}
