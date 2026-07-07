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

  @override
  Future<List<Cliente>> obtenerClientes() async {
    // page_size alto para traer todos de una (para el dropdown).
    final uri = Uri.parse('${Constantes.urlBase}clientes/')
        .replace(queryParameters: {'page_size': '100'});
    try {
      final r = await _cliente.get(uri).timeout(Constantes.timeout);
      if (r.statusCode == 200) {
        final json = jsonDecode(utf8.decode(r.bodyBytes)) as Map<String, dynamic>;
        final lista = json['results'] as List;
        return lista
            .map((e) => ClienteDto.fromJson(e as Map<String, dynamic>).toDomain())
            .toList();
      }
      throw ExcepcionApi('Error del servidor (${r.statusCode}).');
    } on SocketException {
      throw const ExcepcionApi('Sin conexión a internet.');
    } on TimeoutException {
      throw const ExcepcionApi('La petición tardó demasiado.');
    } on FormatException {
      throw const ExcepcionApi('Respuesta inválida del servidor.');
    }
  }
}
