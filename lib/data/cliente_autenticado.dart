import 'package:http/http.dart' as http;

import '../domain/entities/tokens_auth.dart';
import '../domain/usecases/refrescar_token_uc.dart';
import 'almacenamiento_tokens.dart';

class ClienteAutenticado extends http.BaseClient {
  final http.Client _inner;
  final AlmacenamientoTokens _almacenamiento;
  final RefrescarTokenUc _refrescarToken;

  ClienteAutenticado(this._inner, this._almacenamiento, this._refrescarToken);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final access = await _almacenamiento.leerAccess();
    request.headers['Authorization'] = 'Bearer $access';

    var respuesta = await _inner.send(request);

    if (respuesta.statusCode == 401) {
      final refresh = await _almacenamiento.leerRefresh();
      if (refresh != null) {
        try {
          final TokensAuth nuevos = await _refrescarToken(refresh);
          final reintento = _copiar(request);
          reintento.headers['Authorization'] = 'Bearer ${nuevos.access}';
          respuesta = await _inner.send(reintento);
        } catch (_) {}
      }
    }
    return respuesta;
  }

  http.Request _copiar(http.BaseRequest original) {
    final copia = http.Request(original.method, original.url);
    copia.headers.addAll(original.headers);
    copia.followRedirects = original.followRedirects;
    copia.maxRedirects = original.maxRedirects;
    copia.persistentConnection = original.persistentConnection;
    if (original is http.Request) {
      copia.bodyBytes = original.bodyBytes;
      copia.encoding = original.encoding;
    }
    return copia;
  }
}
