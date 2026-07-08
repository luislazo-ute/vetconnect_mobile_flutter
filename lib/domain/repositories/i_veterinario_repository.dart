import '../../data/dtos/pagina_dto.dart';
import '../entities/veterinario.dart';

abstract interface class IVeterinarioRepository {
  Future<PaginaDto<Veterinario>> obtenerVeterinarios({
    int pagina = 1,
    String busqueda = '',
  });

  Future<void> crearVeterinario(Map<String, dynamic> datos);
  Future<void> actualizarVeterinario(int id, Map<String, dynamic> datos);
  Future<void> eliminarVeterinario(int id);
}
