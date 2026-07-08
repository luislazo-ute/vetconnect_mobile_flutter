import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AlmacenamientoTokens {
  final FlutterSecureStorage _storage;

  AlmacenamientoTokens(this._storage);

  static const _kAccess = 'access_token';
  static const _kRefresh = 'refresh_token';

  Future<void> guardar(String access, String refresh) async {
    await _storage.write(key: _kAccess, value: access);
    await _storage.write(key: _kRefresh, value: refresh);
  }

  Future<String?> leerAccess() => _storage.read(key: _kAccess);

  Future<String?> leerRefresh() => _storage.read(key: _kRefresh);

  Future<void> borrar() async {
    await _storage.delete(key: _kAccess);
    await _storage.delete(key: _kRefresh);
  }
}
