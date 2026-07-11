import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../core/constantes.dart';
import '../../core/errores.dart';
import '../../domain/entities/vacuna.dart';
import '../../domain/repositories/i_vacuna_repository.dart';
import '../dtos/pagina_dto.dart';
import '../dtos/vacuna_dto.dart';

class VacunaRepositoryImpl implements IVacunaRepository {
  final http.Client _cliente;
  VacunaRepositoryImpl(this._cliente);

  static const _headers = {'Content-Type': 'application/json'};

  @override
  Future<PaginaDto<Vacuna>> obtenerVacunas({
    int pagina = 1,
    String busqueda = '',
  }) async {
    final uri = Uri.parse('${Constantes.urlBase}vacunas/').replace(
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
          (i) => VacunaDto.fromJson(i).toDomain(),
        );
      }
      throw ExcepcionApi('Error del servidor (${r.statusCode}).');
    });
  }

  @override
  Future<Vacuna> obtenerVacuna(int id) async {
    final uri = Uri.parse('${Constantes.urlBase}vacunas/$id/');
    return _envolver(() async {
      final r = await _cliente.get(uri).timeout(Constantes.timeout);
      if (r.statusCode == 200) {
        return VacunaDto.fromJson(
          jsonDecode(utf8.decode(r.bodyBytes)) as Map<String, dynamic>,
        ).toDomain();
      }
      throw ExcepcionApi('Error del servidor (${r.statusCode}).');
    });
  }

  @override
  Future<Vacuna> crearVacuna(Map<String, dynamic> datos) async {
    final uri = Uri.parse('${Constantes.urlBase}vacunas/');
    return _envolver(() async {
      final r = await _cliente
          .post(uri, headers: _headers, body: jsonEncode(datos))
          .timeout(Constantes.timeout);
      if (r.statusCode == 201) {
        return VacunaDto.fromJson(
          jsonDecode(utf8.decode(r.bodyBytes)) as Map<String, dynamic>,
        ).toDomain();
      }
      throw ExcepcionApi(_mensajeError(r));
    });
  }

  @override
  Future<Vacuna> actualizarVacuna(int id, Map<String, dynamic> datos) async {
    final uri = Uri.parse('${Constantes.urlBase}vacunas/$id/');
    return _envolver(() async {
      final r = await _cliente
          .patch(uri, headers: _headers, body: jsonEncode(datos))
          .timeout(Constantes.timeout);
      if (r.statusCode == 200) {
        return VacunaDto.fromJson(
          jsonDecode(utf8.decode(r.bodyBytes)) as Map<String, dynamic>,
        ).toDomain();
      }
      throw ExcepcionApi(_mensajeError(r));
    });
  }

  @override
  Future<void> eliminarVacuna(int id) async {
    final uri = Uri.parse('${Constantes.urlBase}vacunas/$id/');
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
