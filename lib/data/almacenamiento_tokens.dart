import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Guarda/lee/borra los tokens JWT en almacenamiento cifrado.
class AlmacenamientoTokens {
  final FlutterSecureStorage _storage;

  AlmacenamientoTokens(this._storage);

  // Claves con las que se guardan los tokens.
  static const _kAccess = 'access_token';
  static const _kRefresh = 'refresh_token';

  /// Guarda (o sobreescribe) ambos tokens. Se usa en login y en cada refresh
  /// (el refresh rota, así que siempre reemplazamos el guardado).
  Future<void> guardar(String access, String refresh) async {
    await _storage.write(key: _kAccess, value: access);
    await _storage.write(key: _kRefresh, value: refresh);
  }

  /// Lee el access token (null si no hay sesión).
  Future<String?> leerAccess() => _storage.read(key: _kAccess);

  /// Lee el refresh token.
  Future<String?> leerRefresh() =>  _storage.read(key: _kRefresh);

  /// Borra ambos tokens (logout).
  Future<void> borrar() async {
    await _storage.delete(key: _kAccess);
    await _storage.delete(key: _kRefresh);
  }
}
