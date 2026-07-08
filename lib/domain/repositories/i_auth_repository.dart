import '../entities/tokens_auth.dart';
import '../entities/usuario.dart';

abstract interface class IAuthRepository {
  Future<(TokensAuth, Usuario)> iniciarSesion(String username, String password);

  Future<TokensAuth> refrescarToken(String refresh);

  Future<void> cerrarSesion(String refresh);

  Future<Usuario> obtenerPerfil();
}
