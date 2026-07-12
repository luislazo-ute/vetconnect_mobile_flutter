import '../repositories/i_usuario_admin_repository.dart';

class CrearUsuarioUc {
  final IUsuarioAdminRepository _repo;
  CrearUsuarioUc(this._repo);

  Future<int> call(Map<String, dynamic> datos) => _repo.crearUsuario(datos);
}
