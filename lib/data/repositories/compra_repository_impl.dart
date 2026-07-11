import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../core/constantes.dart';
import '../../core/errores.dart';
import '../../domain/entities/compra.dart';
import '../../domain/entities/detalle_compra.dart';
import '../../domain/repositories/i_compra_repository.dart';
import '../dtos/compra_dto.dart';
import '../dtos/detalle_compra_dto.dart';
import '../dtos/pagina_dto.dart';

class CompraRepositoryImpl implements ICompraRepository {
  final http.Client _cliente;
  CompraRepositoryImpl(this._cliente);

  Uri get _base => Uri.parse('${Constantes.urlBase}compras/');
  Uri get _baseDetalles => Uri.parse('${Constantes.urlBase}detalles-compra/');
  Map<String, String> get _headers => {'Content-Type': 'application/json'};

  @override
  Future<({List<Compra> items, bool hayMas})> obtenerCompras({int pagina = 1}) async {
    final uri = _base.replace(queryParameters: {'page': '$pagina'});
    try {
      final res = await _cliente.get(uri).timeout(Constantes.timeout);
      if (res.statusCode == 200) {
        final json = jsonDecode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>;
        final paginaDto = PaginaDto.fromJson(
          json,
          (item) => CompraDto.fromJson(item).toDomain(),
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
  Future<Compra> obtenerCompra(int id) async {
    try {
      final resCompra = await _cliente
          .get(Uri.parse('${Constantes.urlBase}compras/$id/'))
          .timeout(Constantes.timeout);
      if (resCompra.statusCode != 200) {
        throw ExcepcionApi('Error del servidor (${resCompra.statusCode}).');
      }
      final compra = CompraDto.fromJson(
        jsonDecode(utf8.decode(resCompra.bodyBytes)) as Map<String, dynamic>,
      ).toDomain();

      final detalles = await _obtenerDetalles(id);
      return Compra(
        id: compra.id,
        proveedor: compra.proveedor,
        proveedorNombre: compra.proveedorNombre,
        fechaCompra: compra.fechaCompra,
        numeroFactura: compra.numeroFactura,
        total: compra.total,
        estado: compra.estado,
        detalles: detalles,
      );
    } on SocketException {
      throw const ExcepcionApi('Sin conexión a internet.');
    } on TimeoutException {
      throw const ExcepcionApi('La petición tardó demasiado.');
    }
  }

  Future<List<DetalleCompra>> _obtenerDetalles(int compraId) async {
    final uri = _baseDetalles.replace(queryParameters: {'compra': '$compraId'});
    final res = await _cliente.get(uri).timeout(Constantes.timeout);
    if (res.statusCode != 200) return [];
    final json = jsonDecode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>;
    final lista = (json['results'] as List? ?? []);
    return lista
        .map((d) => DetalleCompraDto.fromJson(d as Map<String, dynamic>).toDomain())
        .toList();
  }

  @override
  Future<Compra> crearCompra({
    required Map<String, dynamic> datos,
    required List<Map<String, dynamic>> detalles,
  }) async {
    try {
      final resCompra = await _cliente
          .post(_base, headers: _headers, body: jsonEncode(datos))
          .timeout(Constantes.timeout);
      if (resCompra.statusCode != 201) {
        throw ExcepcionApi('Error al crear compra (${resCompra.statusCode}).');
      }
      final compra = CompraDto.fromJson(
        jsonDecode(utf8.decode(resCompra.bodyBytes)) as Map<String, dynamic>,
      ).toDomain();

      for (final detalle in detalles) {
        final cuerpo = {...detalle, 'compra': compra.id};
        final resDetalle = await _cliente
            .post(_baseDetalles, headers: _headers, body: jsonEncode(cuerpo))
            .timeout(Constantes.timeout);
        if (resDetalle.statusCode != 201) {
          throw ExcepcionApi('Error al guardar una línea (${resDetalle.statusCode}).');
        }
      }
      return compra;
    } on SocketException {
      throw const ExcepcionApi('Sin conexión a internet.');
    } on TimeoutException {
      throw const ExcepcionApi('La petición tardó demasiado.');
    }
  }

  @override
  Future<void> eliminarCompra(int id) async {
    try {
      final res = await _cliente
          .delete(Uri.parse('${Constantes.urlBase}compras/$id/'))
          .timeout(Constantes.timeout);
      if (res.statusCode != 204) {
        throw ExcepcionApi('Error al eliminar compra (${res.statusCode}).');
      }
    } on SocketException {
      throw const ExcepcionApi('Sin conexión a internet.');
    } on TimeoutException {
      throw const ExcepcionApi('La petición tardó demasiado.');
    }
  }
}
