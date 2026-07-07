import '../../data/dtos/pagina_dto.dart';
import '../entities/veterinario.dart';

/// Contrato del repositorio de veterinarios: define QUÉ operaciones existen,
/// no CÓMO se implementan. La capa data lo implementará.
abstract interface class IVeterinarioRepository {
  Future<PaginaDto<Veterinario>> obtenerVeterinarios({int pagina = 1, String busqueda = ''});
}

