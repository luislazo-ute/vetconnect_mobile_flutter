import '../../data/dtos/pagina_dto.dart';
import '../entities/vacuna.dart';

abstract interface class IVacunaRepository {
  Future<PaginaDto<Vacuna>> obtenerVacunas({
    int pagina = 1,
    String busqueda = '',
  });
  Future<Vacuna> obtenerVacuna(int id);
  Future<Vacuna> crearVacuna(Map<String, dynamic> datos);
  Future<Vacuna> actualizarVacuna(int id, Map<String, dynamic> datos);
  Future<void> eliminarVacuna(int id);
}
