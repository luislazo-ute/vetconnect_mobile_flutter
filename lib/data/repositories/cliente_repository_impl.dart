import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../core/constantes.dart';
import '../../core/errores.dart';
import '../../domain/entities/cliente.dart';
import '../../domain/repositories/i_cliente_repository.dart';
import '../dtos/cliente_dto.dart';

class ClienteRepositoryImpl implements IClienteRepository {
  final http.Client _cliente;

  ClienteRepositoryImpl(this._cliente);

  static const _headers = {'Content-Type': 'application/json'};

  @override
  Future<List<Cliente>> obtenerClientes() {
    final uri = Uri.parse('${Constantes.urlBase}clientes/')
        .replace(queryParameters: {'page_size': '100'});
    return _envolver(() async {
      final r = await _cliente.get(uri).timeout(Constantes.timeout);
      if (r.statusCode == 200) {
        final json = jsonDecode(utf8.decode(r.bodyBytes)) as Map<String, dynamic>;
        final lista = json['results'] as List;
        return lista
            .map((e) => ClienteDto.fromJson(e as Map<String, dynamic>).toDomain())
            .toList();
      }
      throw ExcepcionApi('Error del servidor (${r.statusCode}).');
    });
  }

  @override
  Future<void> actualizarCliente(int id, Map<String, dynamic> datos) {
    final uri = Uri.parse('${Constantes.urlBase}clientes/$id/');
    return _envolver(() async {
      final r = await _cliente
          .patch(uri, headers: _headers, body: jsonEncode(datos))
          .timeout(Constantes.timeout);
      if (r.statusCode != 200) throw ExcepcionApi(_msg(r));
    });
  }

  @override
  Future<void> eliminarCliente(int id) {
    final uri = Uri.parse('${Constantes.urlBase}clientes/$id/');
    return _envolver(() async {
      final r = await _cliente.delete(uri).timeout(Constantes.timeout);
      if (r.statusCode != 204) throw ExcepcionApi(_msg(r));
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
    if (r.statusCode == 400) return 'Datos inválidos.';
    return 'Error del servidor (${r.statusCode}).';
  }
}
