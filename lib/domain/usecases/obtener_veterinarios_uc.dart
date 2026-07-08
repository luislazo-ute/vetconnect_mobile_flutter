import '../../data/dtos/pagina_dto.dart';
import '../entities/veterinario.dart';
import '../repositories/i_veterinario_repository.dart';

class ObtenerVeterinariosUc {
  final IVeterinarioRepository _repo;

  ObtenerVeterinariosUc(this._repo);

  Future<PaginaDto<Veterinario>> call({int pagina = 1, String busqueda = ''}) {
    return _repo.obtenerVeterinarios(pagina: pagina, busqueda: busqueda);
  }
}
