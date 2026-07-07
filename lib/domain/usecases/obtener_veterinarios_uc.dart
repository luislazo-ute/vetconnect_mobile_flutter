import '../../data/dtos/pagina_dto.dart';
import '../entities/veterinario.dart';
import '../repositories/i_veterinario_repository.dart';

/// Caso de uso: obtener veterinarios paginados. Una clase por operación.
class ObtenerVeterinariosUc {
  // Depende de la INTERFAZ, no de la implementación concreta (clave para testear).
  final IVeterinarioRepository _repo;

  ObtenerVeterinariosUc(this._repo);

  /// operator call() permite invocar el objeto como función:
  ///   final pagina = await obtenerVeterinariosUc(pagina: 2);
  Future<PaginaDto<Veterinario>> call({int pagina = 1, String busqueda = ''}) {
    // COMPLETAR: delega en el repo.
    // Pista: return _repo.obtenerVeterinarios(pagina: pagina, busqueda: busqueda);
    return _repo.obtenerVeterinarios(pagina: pagina, busqueda: busqueda);
  }
}
