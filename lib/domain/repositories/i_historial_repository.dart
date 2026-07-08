import '../../data/dtos/pagina_dto.dart';
import '../entities/historial.dart';

abstract interface class IHistorialRepository {
  Future<PaginaDto<Historial>> obtenerHistoriales({
    int pagina = 1,
    String busqueda = '',
  });

  Future<void> crearHistorial(Map<String, dynamic> datos);

  Future<void> actualizarHistorial(int id, Map<String, dynamic> datos);
}
