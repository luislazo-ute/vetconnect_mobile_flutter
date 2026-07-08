import '../repositories/i_veterinario_repository.dart';

class CrearVeterinarioUc {
  final IVeterinarioRepository _repo;
  CrearVeterinarioUc(this._repo);

  Future<void> call(Map<String, dynamic> datos) =>
      _repo.crearVeterinario(datos);
}
