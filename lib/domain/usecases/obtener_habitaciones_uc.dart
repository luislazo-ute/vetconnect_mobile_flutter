import '../../data/dtos/pagina_dto.dart';
import '../entities/habitacion.dart';
import '../repositories/i_habitacion_repository.dart';

class ObtenerHabitacionesUc {
  final IHabitacionRepository _repo;
  ObtenerHabitacionesUc(this._repo);

  Future<PaginaDto<Habitacion>> call({int pagina = 1, String busqueda = ''}) {
    return _repo.obtenerHabitaciones(pagina: pagina, busqueda: busqueda);
  }
}
