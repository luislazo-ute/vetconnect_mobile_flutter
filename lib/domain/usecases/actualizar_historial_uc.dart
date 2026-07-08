import '../repositories/i_historial_repository.dart';

class ActualizarHistorialUc {
  final IHistorialRepository _repo;
  ActualizarHistorialUc(this._repo);

  Future<void> call(int id, Map<String, dynamic> datos) =>
      _repo.actualizarHistorial(id, datos);
}
