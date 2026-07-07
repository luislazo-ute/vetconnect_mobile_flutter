import '../../data/dtos/pagina_dto.dart';
import '../entities/cita.dart';

/// Contrato del repositorio de citas.
abstract interface class ICitaRepository {
  Future<PaginaDto<Cita>> obtenerCitas({int pagina = 1, String busqueda = ''});

  /// Agenda una cita (USUARIO/ADMIN). `datos` = cuerpo JSON.
  Future<void> agendarCita(Map<String, dynamic> datos);

  /// Cambia el estado de una cita (DOCTOR/ADMIN).
  Future<void> cambiarEstado(int id, String estado);
}
