import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../core/constantes.dart';
import '../../core/errores.dart';
import '../../domain/entities/documento_mongo.dart';
import '../../domain/repositories/i_mongo_repository.dart';
import '../dtos/documento_mongo_dto.dart';

/// Implementación genérica para colecciones MongoDB (lista plana, sin paginar).
class MongoRepositoryImpl implements IMongoRepository {
  final http.Client _cliente;

  MongoRepositoryImpl(this._cliente);

  static const _headers = {'Content-Type': 'application/json'};

  @override
  Future<List<DocumentoMongo>> obtener(String coleccion) {
    final uri = Uri.parse('${Constantes.urlBase}mongo/$coleccion/');
    return _envolver(() async {
      final r = await _cliente.get(uri).timeout(Constantes.timeout);
      if (r.statusCode == 200) {
        final lista = jsonDecode(utf8.decode(r.bodyBytes)) as List;
        return lista
            .map((e) => DocumentoMongoDto.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      throw ExcepcionApi('Error del servidor (${r.statusCode}).');
    });
  }

  @override
  Future<void> crear(String coleccion, Map<String, dynamic> datos) {
    final uri = Uri.parse('${Constantes.urlBase}mongo/$coleccion/');
    return _envolver(() async {
      final r = await _cliente
          .post(uri, headers: _headers, body: jsonEncode(datos))
          .timeout(Constantes.timeout);
      if (r.statusCode != 201) {
        throw ExcepcionApi('No se pudo crear (${r.statusCode}).');
      }
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
}
