import '../entities/habitacion.dart';
import '../repositories/i_habitacion_repository.dart';

class ActualizarHabitacionUc {
  final IHabitacionRepository _repo;
  ActualizarHabitacionUc(this._repo);

  Future<Habitacion> call(int id, Map<String, dynamic> datos) =>
      _repo.actualizarHabitacion(id, datos);
}
