import '../entities/tokens_auth.dart';
import '../entities/usuario.dart';

/// Contrato de autenticación.
abstract interface class IAuthRepository {
  /// Login: usuario+clave → tokens + datos del usuario (incluye rol).
  Future<(TokensAuth, Usuario)> iniciarSesion(String username, String password);

  /// Refresca el access usando el refresh; devuelve tokens NUEVOS
  /// (el refresh rota, hay que reemplazar el guardado).
  Future<TokensAuth> refrescarToken(String refresh);

  /// Cierra sesión en el servidor (blacklist del refresh).
  Future<void> cerrarSesion(String refresh);

  /// Obtiene el perfil del usuario autenticado.
  Future<Usuario> obtenerPerfil();
}
