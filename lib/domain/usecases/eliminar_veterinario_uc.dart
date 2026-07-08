import '../repositories/i_veterinario_repository.dart';

class EliminarVeterinarioUc {
  final IVeterinarioRepository _repo;
  EliminarVeterinarioUc(this._repo);

  Future<void> call(int id) => _repo.eliminarVeterinario(id);
}
