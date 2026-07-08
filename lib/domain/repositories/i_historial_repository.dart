import '../../data/dtos/pagina_dto.dart';
import '../entities/historial.dart';

/// Contrato del repositorio de historiales médicos.
abstract interface class IHistorialRepository {
  Future<PaginaDto<Historial>> obtenerHistoriales({int pagina = 1, String busqueda = ''});

  /// Crea un historial (DOCTOR/ADMIN).
  Future<void> crearHistorial(Map<String, dynamic> datos);

  /// Edita un historial (DOCTOR/ADMIN).
  Future<void> actualizarHistorial(int id, Map<String, dynamic> datos);
}
