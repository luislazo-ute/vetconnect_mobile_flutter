import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../core/constantes.dart';
import '../../core/errores.dart';
import '../../domain/entities/notificacion.dart';
import '../../domain/repositories/i_notificacion_repository.dart';
import '../dtos/notificacion_dto.dart';
import '../dtos/pagina_dto.dart';

class NotificacionRepositoryImpl implements INotificacionRepository {
  final http.Client _cliente;
  NotificacionRepositoryImpl(this._cliente);

  static const _headers = {'Content-Type': 'application/json'};

  @override
  Future<PaginaDto<Notificacion>> obtenerNotificaciones({
    int pagina = 1,
    String busqueda = '',
  }) async {
    final uri = Uri.parse('${Constantes.urlBase}notificaciones/').replace(
      queryParameters: {
        'page': '$pagina',
        if (busqueda.isNotEmpty) 'search': busqueda,
      },
    );
    return _envolver(() async {
      final r = await _cliente.get(uri).timeout(Constantes.timeout);
      if (r.statusCode == 200) {
        final json = jsonDecode(utf8.decode(r.bodyBytes)) as Map<String, dynamic>;
        return PaginaDto.fromJson(
          json,
          (i) => NotificacionDto.fromJson(i).toDomain(),
        );
      }
      throw ExcepcionApi('Error del servidor (${r.statusCode}).');
    });
  }

  @override
  Future<void> marcarComoLeida(int id) async {
    final uri = Uri.parse('${Constantes.urlBase}notificaciones/$id/marcar_leida/');
    return _envolver(() async {
      final r = await _cliente
          .patch(uri, headers: _headers, body: jsonEncode({'leida': true}))
          .timeout(Constantes.timeout);
      if (r.statusCode != 200) {
        throw ExcepcionApi(_mensajeError(r));
      }
    });
  }

  @override
  Future<void> marcarTodasComoLeidas() async {
    final uri = Uri.parse('${Constantes.urlBase}notificaciones/marcar_todas_leidas/');
    return _envolver(() async {
      final r = await _cliente
          .patch(uri, headers: _headers)
          .timeout(Constantes.timeout);
      if (r.statusCode != 200) {
        throw ExcepcionApi(_mensajeError(r));
      }
    });
  }

  Future<T> _envolver<T>(Future<T> Function() operacion) async {
    try {
      return await operacion();
    } on SocketException {
      throw const ExcepcionApi('Sin conexión a internet.');
    } on TimeoutException {
      throw const ExcepcionApi('La petición tardó demasiado. Intenta de nuevo.');
    } on FormatException {
      throw const ExcepcionApi('Respuesta inválida del servidor.');
    }
  }

  String _mensajeError(http.Response r) {
    if (r.statusCode == 403) return 'No tienes permiso para esta acción.';
    if (r.statusCode == 401) return 'Sesión expirada. Inicia sesión de nuevo.';
    return 'Error del servidor (${r.statusCode}).';
  }
}
