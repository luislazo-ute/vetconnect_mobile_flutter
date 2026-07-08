import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../core/constantes.dart';
import '../../core/errores.dart';
import '../../domain/entities/cita.dart';
import '../../domain/repositories/i_cita_repository.dart';
import '../dtos/cita_dto.dart';
import '../dtos/pagina_dto.dart';

class CitaRepositoryImpl implements ICitaRepository {
  final http.Client _cliente;

  CitaRepositoryImpl(this._cliente);

  static const _headers = {'Content-Type': 'application/json'};

  @override
  Future<PaginaDto<Cita>> obtenerCitas({int pagina = 1, String busqueda = ''}) {
    final uri = Uri.parse('${Constantes.urlBase}citas/').replace(
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
        return PaginaDto.fromJson(json, (i) => CitaDto.fromJson(i).toDomain());
      }
      throw ExcepcionApi('Error del servidor (${r.statusCode}).');
    });
  }

  @override
  Future<void> agendarCita(Map<String, dynamic> datos) {
    final uri = Uri.parse('${Constantes.urlBase}citas/');
    return _envolver(() async {
      final r = await _cliente
          .post(uri, headers: _headers, body: jsonEncode(datos))
          .timeout(Constantes.timeout);
      if (r.statusCode != 201) throw ExcepcionApi(_mensajeError(r));
    });
  }

  @override
  Future<void> cambiarEstado(int id, String estado) {
    final uri = Uri.parse('${Constantes.urlBase}citas/$id/');
    return _envolver(() async {
      final r = await _cliente
          .patch(uri, headers: _headers, body: jsonEncode({'estado': estado}))
          .timeout(Constantes.timeout);
      if (r.statusCode != 200) throw ExcepcionApi(_mensajeError(r));
    });
  }

  Future<T> _envolver<T>(Future<T> Function() operacion) async {
    try {
      return await operacion();
    } on SocketException {
      throw const ExcepcionApi('Sin conexión a internet.');
    } on TimeoutException {
      throw const ExcepcionApi(
        'La petición tardó demasiado. Intenta de nuevo.',
      );
    } on FormatException {
      throw const ExcepcionApi('Respuesta inválida del servidor.');
    }
  }

  String _mensajeError(http.Response r) {
    if (r.statusCode == 403) return 'No tienes permiso para esta acción.';
    if (r.statusCode == 401) return 'Sesión expirada. Inicia sesión de nuevo.';
    if (r.statusCode == 400) return 'Datos inválidos. Revisa el formulario.';
    return 'Error del servidor (${r.statusCode}).';
  }
}
