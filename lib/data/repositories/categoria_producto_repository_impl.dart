import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../core/constantes.dart';
import '../../core/errores.dart';
import '../../domain/entities/categoria_producto.dart';
import '../../domain/repositories/i_categoria_producto_repository.dart';
import '../dtos/categoria_producto_dto.dart';
import '../dtos/pagina_dto.dart';

class CategoriaProductoRepositoryImpl implements ICategoriaProductoRepository {
  final http.Client _cliente;
  CategoriaProductoRepositoryImpl(this._cliente);

  Uri get _base => Uri.parse('${Constantes.urlBase}categorias-producto/');

  Map<String, String> get _headers => {'Content-Type': 'application/json'};

  @override
  Future<({List<CategoriaProducto> items, bool hayMas})> obtenerCategorias({
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
          (item) => CategoriaProductoDto.fromJson(item).toDomain(),
        );
        return (items: paginaDto.results, hayMas: paginaDto.hayMas);
      }
      throw ExcepcionApi('Error del servidor (${res.statusCode}).');
    } on SocketException {
      throw const ExcepcionApi('Sin conexión a internet.');
    } on TimeoutException {
      throw const ExcepcionApi('La petición tardó demasiado. Intenta de nuevo.');
    }
  }

  @override
  Future<CategoriaProducto> obtenerCategoria(int id) async {
    try {
      final res = await _cliente
          .get(Uri.parse('${Constantes.urlBase}categorias-producto/$id/'))
          .timeout(Constantes.timeout);
      if (res.statusCode == 200) {
        return CategoriaProductoDto.fromJson(
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
  Future<CategoriaProducto> crearCategoria(Map<String, dynamic> datos) async {
    try {
      final res = await _cliente
          .post(_base, headers: _headers, body: jsonEncode(datos))
          .timeout(Constantes.timeout);
      if (res.statusCode == 201) {
        return CategoriaProductoDto.fromJson(
          jsonDecode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>,
        ).toDomain();
      }
      throw ExcepcionApi('Error al crear categoría (${res.statusCode}).');
    } on SocketException {
      throw const ExcepcionApi('Sin conexión a internet.');
    } on TimeoutException {
      throw const ExcepcionApi('La petición tardó demasiado.');
    }
  }

  @override
  Future<CategoriaProducto> actualizarCategoria(
      int id, Map<String, dynamic> datos) async {
    try {
      final res = await _cliente
          .patch(
            Uri.parse('${Constantes.urlBase}categorias-producto/$id/'),
            headers: _headers,
            body: jsonEncode(datos),
          )
          .timeout(Constantes.timeout);
      if (res.statusCode == 200) {
        return CategoriaProductoDto.fromJson(
          jsonDecode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>,
        ).toDomain();
      }
      throw ExcepcionApi('Error al actualizar categoría (${res.statusCode}).');
    } on SocketException {
      throw const ExcepcionApi('Sin conexión a internet.');
    } on TimeoutException {
      throw const ExcepcionApi('La petición tardó demasiado.');
    }
  }

  @override
  Future<void> eliminarCategoria(int id) async {
    try {
      final res = await _cliente
          .delete(Uri.parse('${Constantes.urlBase}categorias-producto/$id/'))
          .timeout(Constantes.timeout);
      if (res.statusCode != 204) {
        throw ExcepcionApi('Error al eliminar categoría (${res.statusCode}).');
      }
    } on SocketException {
      throw const ExcepcionApi('Sin conexión a internet.');
    } on TimeoutException {
      throw const ExcepcionApi('La petición tardó demasiado.');
    }
  }
}
