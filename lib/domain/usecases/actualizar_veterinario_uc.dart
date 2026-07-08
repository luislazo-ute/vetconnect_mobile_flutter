import '../repositories/i_veterinario_repository.dart';

class ActualizarVeterinarioUc {
  final IVeterinarioRepository _repo;
  ActualizarVeterinarioUc(this._repo);

  Future<void> call(int id, Map<String, dynamic> datos) =>
      _repo.actualizarVeterinario(id, datos);
}
