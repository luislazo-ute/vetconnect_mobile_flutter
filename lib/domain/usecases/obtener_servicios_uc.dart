import '../../data/dtos/pagina_dto.dart';
import '../entities/servicio.dart';
import '../repositories/i_servicio_repository.dart';

/// Caso de uso: obtener servicios paginados. Una clase por operación.
class ObtenerServiciosUc {
  // Depende de la INTERFAZ, no de la implementación concreta (clave para testear).
  final IServicioRepository _repo;

  ObtenerServiciosUc(this._repo);

  /// operator call() permite invocar el objeto como función:
  ///   final pagina = await obtenerServiciosUc(pagina: 2);
  Future<PaginaDto<Servicio>> call({int pagina = 1, String busqueda = ''}) {
    // COMPLETAR: delega en el repo.
    // Pista: return _repo.obtenerServicios(pagina: pagina, busqueda: busqueda);
    return _repo.obtenerServicios(pagina: pagina, busqueda: busqueda);
  }
}
