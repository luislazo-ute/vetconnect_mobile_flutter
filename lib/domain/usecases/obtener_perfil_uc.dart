import '../entities/usuario.dart';
import '../repositories/i_auth_repository.dart';

class ObtenerPerfilUc {
  final IAuthRepository _repo;
  ObtenerPerfilUc(this._repo);

  Future<Usuario> call() => _repo.obtenerPerfil();
}
