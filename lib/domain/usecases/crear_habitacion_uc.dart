import '../entities/habitacion.dart';
import '../repositories/i_habitacion_repository.dart';

class CrearHabitacionUc {
  final IHabitacionRepository _repo;
  CrearHabitacionUc(this._repo);

  Future<Habitacion> call(Map<String, dynamic> datos) =>
      _repo.crearHabitacion(datos);
}
