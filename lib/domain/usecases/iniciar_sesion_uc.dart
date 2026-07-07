import '../entities/tokens_auth.dart';
import '../entities/usuario.dart';
import '../repositories/i_auth_repository.dart';

class IniciarSesionUc {
  final IAuthRepository _repo;
  IniciarSesionUc(this._repo);

  Future<(TokensAuth, Usuario)> call(String username, String password) {
    // COMPLETAR: delega en el repo.
    // Pista: return _repo.iniciarSesion(username, password);
    return _repo.iniciarSesion(username, password);
  }
}
