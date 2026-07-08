import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../core/constantes.dart';
import '../../core/errores.dart';
import '../../domain/entities/galeria_foto.dart';
import '../../domain/repositories/i_galeria_repository.dart';
import '../dtos/galeria_foto_dto.dart';

class GaleriaRepositoryImpl implements IGaleriaRepository {
  final http.Client _cliente;

  GaleriaRepositoryImpl(this._cliente);

  static const _headers = {'Content-Type': 'application/json'};

  @override
  Future<List<GaleriaFoto>> obtenerGaleria() {
    final uri = Uri.parse('${Constantes.urlBase}mongo/galeria-mascota/');
    return _envolver(() async {
      final r = await _cliente.get(uri).timeout(Constantes.timeout);
      if (r.statusCode == 200) {
        final lista = jsonDecode(utf8.decode(r.bodyBytes)) as List;
        return lista
            .map(
              (e) =>
                  GaleriaFotoDto.fromJson(e as Map<String, dynamic>).toDomain(),
            )
            .toList();
      }
      throw ExcepcionApi('Error del servidor (${r.statusCode}).');
    });
  }

  @override
  Future<void> crearFoto(Map<String, dynamic> datos) {
    final uri = Uri.parse('${Constantes.urlBase}mongo/galeria-mascota/');
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
