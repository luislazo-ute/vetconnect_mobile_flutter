import '../entities/habitacion.dart';
import '../repositories/i_habitacion_repository.dart';

class ObtenerHabitacionPorIdUc {
  final IHabitacionRepository _repo;
  ObtenerHabitacionPorIdUc(this._repo);

  Future<Habitacion> call(int id) => _repo.obtenerHabitacion(id);
}
