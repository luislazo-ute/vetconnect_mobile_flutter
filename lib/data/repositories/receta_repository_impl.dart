import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../core/constantes.dart';
import '../../core/errores.dart';
import '../../domain/entities/detalle_receta.dart';
import '../../domain/entities/receta.dart';
import '../../domain/repositories/i_receta_repository.dart';
import '../dtos/detalle_receta_dto.dart';
import '../dtos/pagina_dto.dart';
import '../dtos/receta_dto.dart';

class RecetaRepositoryImpl implements IRecetaRepository {
  final http.Client _cliente;
  RecetaRepositoryImpl(this._cliente);

  static const _headers = {'Content-Type': 'application/json'};

  Uri get _baseDetalles => Uri.parse('${Constantes.urlBase}detalles-receta/');

  @override
  Future<PaginaDto<Receta>> obtenerRecetas({
    int pagina = 1,
    String busqueda = '',
  }) async {
    final uri = Uri.parse('${Constantes.urlBase}recetas/').replace(
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
          (i) => RecetaDto.fromJson(i).toDomain(),
        );
      }
      throw ExcepcionApi('Error del servidor (${r.statusCode}).');
    });
  }

  @override
  Future<Receta> obtenerReceta(int id) async {
    final uri = Uri.parse('${Constantes.urlBase}recetas/$id/');
    return _envolver(() async {
      final r = await _cliente.get(uri).timeout(Constantes.timeout);
      if (r.statusCode != 200) {
        throw ExcepcionApi('Error del servidor (${r.statusCode}).');
      }
      final receta = RecetaDto.fromJson(
        jsonDecode(utf8.decode(r.bodyBytes)) as Map<String, dynamic>,
      ).toDomain();
      final detalles = await _obtenerDetalles(id);
      return Receta(
        id: receta.id,
        mascota: receta.mascota,
        mascotaNombre: receta.mascotaNombre,
        veterinario: receta.veterinario,
        veterinarioNombre: receta.veterinarioNombre,
        fecha: receta.fecha,
        observaciones: receta.observaciones,
        detalles: detalles,
      );
    });
  }

  Future<List<DetalleReceta>> _obtenerDetalles(int recetaId) async {
    final uri = _baseDetalles.replace(queryParameters: {'receta': '$recetaId'});
    final r = await _cliente.get(uri).timeout(Constantes.timeout);
    if (r.statusCode != 200) return [];
    final json = jsonDecode(utf8.decode(r.bodyBytes)) as Map<String, dynamic>;
    final lista = (json['results'] as List? ?? []);
    return lista
        .map((d) => DetalleRecetaDto.fromJson(d as Map<String, dynamic>).toDomain())
        .toList();
  }

  @override
  Future<Receta> crearReceta({
    required Map<String, dynamic> datos,
    required List<Map<String, dynamic>> detalles,
  }) async {
    final uri = Uri.parse('${Constantes.urlBase}recetas/');
    return _envolver(() async {
      final r = await _cliente
          .post(uri, headers: _headers, body: jsonEncode(datos))
          .timeout(Constantes.timeout);
      if (r.statusCode != 201) {
        throw ExcepcionApi(_mensajeError(r));
      }
      final receta = RecetaDto.fromJson(
        jsonDecode(utf8.decode(r.bodyBytes)) as Map<String, dynamic>,
      ).toDomain();

      for (final detalle in detalles) {
        final cuerpo = {...detalle, 'receta': receta.id};
        final rd = await _cliente
            .post(_baseDetalles, headers: _headers, body: jsonEncode(cuerpo))
            .timeout(Constantes.timeout);
        if (rd.statusCode != 201) {
          throw ExcepcionApi('Error al guardar un medicamento (${rd.statusCode}).');
        }
      }
      return receta;
    });
  }

  @override
  Future<Receta> actualizarReceta(int id, Map<String, dynamic> datos) async {
    final uri = Uri.parse('${Constantes.urlBase}recetas/$id/');
    return _envolver(() async {
      final r = await _cliente
          .patch(uri, headers: _headers, body: jsonEncode(datos))
          .timeout(Constantes.timeout);
      if (r.statusCode == 200) {
        return RecetaDto.fromJson(
          jsonDecode(utf8.decode(r.bodyBytes)) as Map<String, dynamic>,
        ).toDomain();
      }
      throw ExcepcionApi(_mensajeError(r));
    });
  }

  @override
  Future<void> eliminarReceta(int id) async {
    final uri = Uri.parse('${Constantes.urlBase}recetas/$id/');
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
