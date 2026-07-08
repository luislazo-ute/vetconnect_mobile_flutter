import '../repositories/i_historial_repository.dart';

class CrearHistorialUc {
  final IHistorialRepository _repo;
  CrearHistorialUc(this._repo);

  Future<void> call(Map<String, dynamic> datos) => _repo.crearHistorial(datos);
}
