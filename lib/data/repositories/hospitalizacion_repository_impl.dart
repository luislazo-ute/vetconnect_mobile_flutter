import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../core/constantes.dart';
import '../../core/errores.dart';
import '../../domain/entities/hospitalizacion.dart';
import '../../domain/repositories/i_hospitalizacion_repository.dart';
import '../dtos/hospitalizacion_dto.dart';
import '../dtos/pagina_dto.dart';

class HospitalizacionRepositoryImpl implements IHospitalizacionRepository {
  final http.Client _cliente;
  HospitalizacionRepositoryImpl(this._cliente);

  static const _headers = {'Content-Type': 'application/json'};

  @override
  Future<PaginaDto<Hospitalizacion>> obtenerHospitalizaciones({
    int pagina = 1,
    String busqueda = '',
  }) async {
    final uri = Uri.parse('${Constantes.urlBase}hospitalizaciones/').replace(
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
          (i) => HospitalizacionDto.fromJson(i).toDomain(),
        );
      }
      throw ExcepcionApi('Error del servidor (${r.statusCode}).');
    });
  }

  @override
  Future<Hospitalizacion> obtenerHospitalizacion(int id) async {
    final uri = Uri.parse('${Constantes.urlBase}hospitalizaciones/$id/');
    return _envolver(() async {
      final r = await _cliente.get(uri).timeout(Constantes.timeout);
      if (r.statusCode == 200) {
        return HospitalizacionDto.fromJson(
          jsonDecode(utf8.decode(r.bodyBytes)) as Map<String, dynamic>,
        ).toDomain();
      }
      throw ExcepcionApi('Error del servidor (${r.statusCode}).');
    });
  }

  @override
  Future<Hospitalizacion> crearHospitalizacion(Map<String, dynamic> datos) async {
    final uri = Uri.parse('${Constantes.urlBase}hospitalizaciones/');
    return _envolver(() async {
      final r = await _cliente
          .post(uri, headers: _headers, body: jsonEncode(datos))
          .timeout(Constantes.timeout);
      if (r.statusCode == 201) {
        return HospitalizacionDto.fromJson(
          jsonDecode(utf8.decode(r.bodyBytes)) as Map<String, dynamic>,
        ).toDomain();
      }
      throw ExcepcionApi(_mensajeError(r));
    });
  }

  @override
  Future<Hospitalizacion> actualizarHospitalizacion(int id, Map<String, dynamic> datos) async {
    final uri = Uri.parse('${Constantes.urlBase}hospitalizaciones/$id/');
    return _envolver(() async {
      final r = await _cliente
          .patch(uri, headers: _headers, body: jsonEncode(datos))
          .timeout(Constantes.timeout);
      if (r.statusCode == 200) {
        return HospitalizacionDto.fromJson(
          jsonDecode(utf8.decode(r.bodyBytes)) as Map<String, dynamic>,
        ).toDomain();
      }
      throw ExcepcionApi(_mensajeError(r));
    });
  }

  @override
  Future<void> eliminarHospitalizacion(int id) async {
    final uri = Uri.parse('${Constantes.urlBase}hospitalizaciones/$id/');
    return _envolver(() async {
      final r = await _cliente.delete(uri).timeout(Constantes.timeout);
      if (r.statusCode != 204) {
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
