import '../../data/dtos/pagina_dto.dart';
import '../entities/habitacion.dart';

abstract interface class IHabitacionRepository {
  Future<PaginaDto<Habitacion>> obtenerHabitaciones({
    int pagina = 1,
    String busqueda = '',
  });
  Future<Habitacion> obtenerHabitacion(int id);
  Future<Habitacion> crearHabitacion(Map<String, dynamic> datos);
  Future<Habitacion> actualizarHabitacion(int id, Map<String, dynamic> datos);
  Future<void> eliminarHabitacion(int id);
}
