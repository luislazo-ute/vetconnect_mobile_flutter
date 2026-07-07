import 'package:http/http.dart' as http;

import '../domain/entities/tokens_auth.dart';
import '../domain/usecases/refrescar_token_uc.dart';
import 'almacenamiento_tokens.dart';

/// Cliente HTTP que:
///  1. Adjunta el access token (Bearer) a CADA petición.
///  2. Si el servidor responde 401 (access expirado), refresca el token,
///     guarda el nuevo (el refresh rota) y REINTENTA la petición una vez.
///
/// Es un "interceptor": el resto de la app hace get/post normal y no se
/// entera de la renovación. Kevin y Johan lo consumen tal cual.
class ClienteAutenticado extends http.BaseClient {
  final http.Client _inner; // el cliente base que hace la red de verdad
  final AlmacenamientoTokens _almacenamiento;
  final RefrescarTokenUc _refrescarToken;

  ClienteAutenticado(this._inner, this._almacenamiento, this._refrescarToken);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    // 1) Adjunta el access token actual.
    final access = await _almacenamiento.leerAccess();
    request.headers['Authorization'] = 'Bearer $access';

    var respuesta = await _inner.send(request);

    // 2) ¿Access expirado? Refresca y reintenta UNA vez.
    if (respuesta.statusCode == 401) {
      final refresh = await _almacenamiento.leerRefresh();
      if (refresh != null) {
        try {
          // Refresca (y guarda los tokens nuevos por dentro).
          final TokensAuth nuevos = await _refrescarToken(refresh);
          // Un request no se puede reenviar: hay que clonarlo.
          final reintento = _copiar(request);
          reintento.headers['Authorization'] = 'Bearer ${nuevos.access}';
          respuesta = await _inner.send(reintento);
        } catch (_) {
          // Si el refresh falla, devolvemos la 401 original (sesión caída).
        }
      }
    }
    return respuesta;
  }

  /// Clona un request para poder reenviarlo (copia método, url, headers y body).
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
