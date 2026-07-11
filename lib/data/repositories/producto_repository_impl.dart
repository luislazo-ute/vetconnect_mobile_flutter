import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../core/constantes.dart';
import '../../core/errores.dart';
import '../../domain/entities/producto.dart';
import '../../domain/repositories/i_producto_repository.dart';
import '../dtos/pagina_dto.dart';
import '../dtos/producto_dto.dart';

class ProductoRepositoryImpl implements IProductoRepository {
  final http.Client _cliente;
  ProductoRepositoryImpl(this._cliente);

  Uri get _base => Uri.parse('${Constantes.urlBase}productos/');
  Map<String, String> get _headers => {'Content-Type': 'application/json'};

  @override
  Future<({List<Producto> items, bool hayMas})> obtenerProductos({
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
          (item) => ProductoDto.fromJson(item).toDomain(),
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
  Future<Producto> obtenerProducto(int id) async {
    try {
      final res = await _cliente
          .get(Uri.parse('${Constantes.urlBase}productos/$id/'))
          .timeout(Constantes.timeout);
      if (res.statusCode == 200) {
        return ProductoDto.fromJson(
          jsonDecode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>,
        ).toDomain();
      }
      throw ExcepcionApi('Error del servidor (${res.statusCode}).');
    } on SocketException {
      throw const ExcepcionApi('Sin conexión a internet.');
    } on TimeoutException {
      throw const ExcepcionApi('La petición tardó demasiado.');
    }
  }

  @override
  Future<Producto> crearProducto(Map<String, dynamic> datos) async {
    try {
      final res = await _cliente
          .post(_base, headers: _headers, body: jsonEncode(datos))
          .timeout(Constantes.timeout);
      if (res.statusCode == 201) {
        return ProductoDto.fromJson(
          jsonDecode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>,
        ).toDomain();
      }
      throw ExcepcionApi('Error al crear producto (${res.statusCode}).');
    } on SocketException {
      throw const ExcepcionApi('Sin conexión a internet.');
    } on TimeoutException {
      throw const ExcepcionApi('La petición tardó demasiado.');
    }
  }

  @override
  Future<Producto> actualizarProducto(int id, Map<String, dynamic> datos) async {
    try {
      final res = await _cliente
          .patch(
            Uri.parse('${Constantes.urlBase}productos/$id/'),
            headers: _headers,
            body: jsonEncode(datos),
          )
          .timeout(Constantes.timeout);
      if (res.statusCode == 200) {
        return ProductoDto.fromJson(
          jsonDecode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>,
        ).toDomain();
      }
      throw ExcepcionApi('Error al actualizar producto (${res.statusCode}).');
    } on SocketException {
      throw const ExcepcionApi('Sin conexión a internet.');
    } on TimeoutException {
      throw const ExcepcionApi('La petición tardó demasiado.');
    }
  }

  @override
  Future<void> eliminarProducto(int id) async {
    try {
      final res = await _cliente
          .delete(Uri.parse('${Constantes.urlBase}productos/$id/'))
          .timeout(Constantes.timeout);
      if (res.statusCode != 204) {
        throw ExcepcionApi('Error al eliminar producto (${res.statusCode}).');
      }
    } on SocketException {
      throw const ExcepcionApi('Sin conexión a internet.');
    } on TimeoutException {
      throw const ExcepcionApi('La petición tardó demasiado.');
    }
  }
}
