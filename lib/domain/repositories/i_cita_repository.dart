import '../../data/dtos/pagina_dto.dart';
import '../entities/cita.dart';

abstract interface class ICitaRepository {
  Future<PaginaDto<Cita>> obtenerCitas({int pagina = 1, String busqueda = ''});

  Future<void> agendarCita(Map<String, dynamic> datos);

  Future<void> cambiarEstado(int id, String estado);
}
