import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../core/constantes.dart';
import '../../core/errores.dart';
import '../../domain/entities/proveedor.dart';
import '../../domain/repositories/i_proveedor_repository.dart';
import '../dtos/pagina_dto.dart';
import '../dtos/proveedor_dto.dart';

class ProveedorRepositoryImpl implements IProveedorRepository {
  final http.Client _cliente;
  ProveedorRepositoryImpl(this._cliente);

  Uri get _base => Uri.parse('${Constantes.urlBase}proveedores/');
  Map<String, String> get _headers => {'Content-Type': 'application/json'};

  @override
  Future<({List<Proveedor> items, bool hayMas})> obtenerProveedores({
    int pagina = 1,
    String busqueda = '',
  }) async {
    final uri = _base.replace(queryParameters: {
      'page': '$pagina',
      if (busqueda.isNotEmpty) 'search': busqueda,
    });
    try {
      final res = await _cliente.get(uri).timeout(Constantes.timeout);
      if (res.statusCode == 200) {
        final json = jsonDecode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>;
        final paginaDto = PaginaDto.fromJson(
          json,
          (item) => ProveedorDto.fromJson(item).toDomain(),
        );
        return (items: paginaDto.results, hayMas: paginaDto.hayMas);
      }
      throw ExcepcionApi('Error del servidor (${res.statusCode}).');
    } on SocketException {
      throw const ExcepcionApi('Sin conexión a internet.');
    } on TimeoutException {
      throw const ExcepcionApi('La petición tardó demasiado.');
    }
  }

  @override
  Future<Proveedor> crearProveedor(Map<String, dynamic> datos) async {
    try {
      final res = await _cliente
          .post(_base, headers: _headers, body: jsonEncode(datos))
          .timeout(Constantes.timeout);
      if (res.statusCode == 201) {
        return ProveedorDto.fromJson(
          jsonDecode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>,
        ).toDomain();
      }
      throw ExcepcionApi('Error al crear proveedor (${res.statusCode}).');
    } on SocketException {
      throw const ExcepcionApi('Sin conexión a internet.');
    } on TimeoutException {
      throw const ExcepcionApi('La petición tardó demasiado.');
    }
  }

  @override
  Future<Proveedor> actualizarProveedor(int id, Map<String, dynamic> datos) async {
    try {
      final res = await _cliente
          .patch(
            Uri.parse('${Constantes.urlBase}proveedores/$id/'),
            headers: _headers,
            body: jsonEncode(datos),
          )
          .timeout(Constantes.timeout);
      if (res.statusCode == 200) {
        return ProveedorDto.fromJson(
          jsonDecode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>,
        ).toDomain();
      }
      throw ExcepcionApi('Error al actualizar proveedor (${res.statusCode}).');
    } on SocketException {
      throw const ExcepcionApi('Sin conexión a internet.');
    } on TimeoutException {
      throw const ExcepcionApi('La petición tardó demasiado.');
    }
  }

  @override
  Future<void> eliminarProveedor(int id) async {
    try {
      final res = await _cliente
          .delete(Uri.parse('${Constantes.urlBase}proveedores/$id/'))
          .timeout(Constantes.timeout);
      if (res.statusCode != 204) {
        throw ExcepcionApi('Error al eliminar proveedor (${res.statusCode}).');
      }
    } on SocketException {
      throw const ExcepcionApi('Sin conexión a internet.');
    } on TimeoutException {
      throw const ExcepcionApi('La petición tardó demasiado.');
    }
  }
}
