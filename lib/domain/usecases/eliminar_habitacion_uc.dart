import '../repositories/i_habitacion_repository.dart';

class EliminarHabitacionUc {
  final IHabitacionRepository _repo;
  EliminarHabitacionUc(this._repo);

  Future<void> call(int id) => _repo.eliminarHabitacion(id);
}
