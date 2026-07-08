import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../core/constantes.dart';
import '../../core/errores.dart';
import '../../domain/entities/historial.dart';
import '../../domain/repositories/i_historial_repository.dart';
import '../dtos/historial_dto.dart';
import '../dtos/pagina_dto.dart';

class HistorialRepositoryImpl implements IHistorialRepository {
  final http.Client _cliente;

  HistorialRepositoryImpl(this._cliente);

  static const _headers = {'Content-Type': 'application/json'};

  @override
  Future<PaginaDto<Historial>> obtenerHistoriales({
    int pagina = 1,
    String busqueda = '',
  }) {
    final uri = Uri.parse('${Constantes.urlBase}historiales/').replace(
      queryParameters: {
        'page': '$pagina',
        if (busqueda.isNotEmpty) 'search': busqueda,
      },
    );
    return _envolver(() async {
      final r = await _cliente.get(uri).timeout(Constantes.timeout);
      if (r.statusCode == 200) {
        final json =
            jsonDecode(utf8.decode(r.bodyBytes)) as Map<String, dynamic>;
        return PaginaDto.fromJson(
          json,
          (i) => HistorialDto.fromJson(i).toDomain(),
        );
      }
      throw ExcepcionApi('Error del servidor (${r.statusCode}).');
    });
  }

  @override
  Future<void> crearHistorial(Map<String, dynamic> datos) {
    final uri = Uri.parse('${Constantes.urlBase}historiales/');
    return _envolver(() async {
      final r = await _cliente
          .post(uri, headers: _headers, body: jsonEncode(datos))
          .timeout(Constantes.timeout);
      if (r.statusCode != 201) throw ExcepcionApi(_msg(r));
    });
  }

  @override
  Future<void> actualizarHistorial(int id, Map<String, dynamic> datos) {
    final uri = Uri.parse('${Constantes.urlBase}historiales/$id/');
    return _envolver(() async {
      final r = await _cliente
          .patch(uri, headers: _headers, body: jsonEncode(datos))
          .timeout(Constantes.timeout);
      if (r.statusCode != 200) throw ExcepcionApi(_msg(r));
    });
  }

  Future<T> _envolver<T>(Future<T> Function() op) async {
    try {
      return await op();
    } on SocketException {
      throw const ExcepcionApi('Sin conexión a internet.');
    } on TimeoutException {
      throw const ExcepcionApi('La petición tardó demasiado.');
    } on FormatException {
      throw const ExcepcionApi('Respuesta inválida del servidor.');
    }
  }

  String _msg(http.Response r) {
    if (r.statusCode == 403) return 'No tienes permiso para esta acción.';
    if (r.statusCode == 400) return 'Datos inválidos. Revisa el formulario.';
    return 'Error del servidor (${r.statusCode}).';
  }
}
