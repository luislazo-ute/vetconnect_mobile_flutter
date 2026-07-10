import '../../data/dtos/pagina_dto.dart';
import '../entities/receta.dart';

abstract interface class IRecetaRepository {
  Future<PaginaDto<Receta>> obtenerRecetas({
    int pagina = 1,
    String busqueda = '',
  });
  Future<Receta> obtenerReceta(int id);
  Future<Receta> crearReceta(Map<String, dynamic> datos);
  Future<Receta> actualizarReceta(int id, Map<String, dynamic> datos);
  Future<void> eliminarReceta(int id);
}
