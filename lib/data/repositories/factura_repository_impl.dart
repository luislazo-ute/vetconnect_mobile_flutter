import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../core/constantes.dart';
import '../../core/errores.dart';
import '../../domain/entities/detalle_factura.dart';
import '../../domain/entities/factura.dart';
import '../../domain/entities/pago.dart';
import '../../domain/repositories/i_factura_repository.dart';
import '../dtos/detalle_factura_dto.dart';
import '../dtos/factura_dto.dart';
import '../dtos/pago_dto.dart';
import '../dtos/pagina_dto.dart';

class FacturaRepositoryImpl implements IFacturaRepository {
  final http.Client _cliente;
  FacturaRepositoryImpl(this._cliente);

  Uri get _base => Uri.parse('${Constantes.urlBase}facturas/');
  Uri get _baseDetalles => Uri.parse('${Constantes.urlBase}detalles-factura/');
  Uri get _basePagos => Uri.parse('${Constantes.urlBase}pagos/');
  Map<String, String> get _headers => {'Content-Type': 'application/json'};

  @override
  Future<({List<Factura> items, bool hayMas})> obtenerFacturas({int pagina = 1}) async {
    final uri = _base.replace(queryParameters: {'page': '$pagina'});
    try {
      final res = await _cliente.get(uri).timeout(Constantes.timeout);
      if (res.statusCode == 200) {
        final json = jsonDecode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>;
        final paginaDto = PaginaDto.fromJson(
          json,
          (item) => FacturaDto.fromJson(item).toDomain(),
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
  Future<Factura> obtenerFactura(int id) async {
    try {
      final resFactura = await _cliente
          .get(Uri.parse('${Constantes.urlBase}facturas/$id/'))
          .timeout(Constantes.timeout);
      if (resFactura.statusCode != 200) {
        throw ExcepcionApi('Error del servidor (${resFactura.statusCode}).');
      }
      final factura = FacturaDto.fromJson(
        jsonDecode(utf8.decode(resFactura.bodyBytes)) as Map<String, dynamic>,
      ).toDomain();

      final detalles = await _obtenerDetalles(id);
      final pagos = await _obtenerPagos(id);
      return Factura(
        id: factura.id,
        cliente: factura.cliente,
        clienteUsername: factura.clienteUsername,
        fecha: factura.fecha,
        total: factura.total,
        pagada: factura.pagada,
        detalles: detalles,
        pagos: pagos,
      );
    } on SocketException {
      throw const ExcepcionApi('Sin conexión a internet.');
    } on TimeoutException {
      throw const ExcepcionApi('La petición tardó demasiado.');
    }
  }

  Future<List<DetalleFactura>> _obtenerDetalles(int facturaId) async {
    final uri = _baseDetalles.replace(queryParameters: {'factura': '$facturaId'});
    final res = await _cliente.get(uri).timeout(Constantes.timeout);
    if (res.statusCode != 200) return [];
    final json = jsonDecode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>;
    final lista = (json['results'] as List? ?? []);
    return lista
        .map((d) => DetalleFacturaDto.fromJson(d as Map<String, dynamic>).toDomain())
        .toList();
  }

  Future<List<Pago>> _obtenerPagos(int facturaId) async {
    final uri = _basePagos.replace(queryParameters: {'factura': '$facturaId'});
    final res = await _cliente.get(uri).timeout(Constantes.timeout);
    if (res.statusCode != 200) return [];
    final json = jsonDecode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>;
    final lista = (json['results'] as List? ?? []);
    return lista
        .map((p) => PagoDto.fromJson(p as Map<String, dynamic>).toDomain())
        .toList();
  }

  @override
  Future<Factura> crearFactura({
    required Map<String, dynamic> datos,
    required List<Map<String, dynamic>> detalles,
  }) async {
    try {
      final resFactura = await _cliente
          .post(_base, headers: _headers, body: jsonEncode(datos))
          .timeout(Constantes.timeout);
      if (resFactura.statusCode != 201) {
        throw ExcepcionApi('Error al crear factura (${resFactura.statusCode}).');
      }
      final factura = FacturaDto.fromJson(
        jsonDecode(utf8.decode(resFactura.bodyBytes)) as Map<String, dynamic>,
      ).toDomain();

      for (final detalle in detalles) {
        final cuerpo = {...detalle, 'factura': factura.id};
        final resDetalle = await _cliente
            .post(_baseDetalles, headers: _headers, body: jsonEncode(cuerpo))
            .timeout(Constantes.timeout);
        if (resDetalle.statusCode != 201) {
          throw ExcepcionApi('Error al guardar una línea (${resDetalle.statusCode}).');
        }
      }
      return factura;
    } on SocketException {
      throw const ExcepcionApi('Sin conexión a internet.');
    } on TimeoutException {
      throw const ExcepcionApi('La petición tardó demasiado.');
    }
  }

  @override
  Future<void> registrarPago(Map<String, dynamic> datos) async {
    try {
      final res = await _cliente
          .post(_basePagos, headers: _headers, body: jsonEncode(datos))
          .timeout(Constantes.timeout);
      if (res.statusCode != 201) {
        throw ExcepcionApi('Error al registrar pago (${res.statusCode}).');
      }
    } on SocketException {
      throw const ExcepcionApi('Sin conexión a internet.');
    } on TimeoutException {
      throw const ExcepcionApi('La petición tardó demasiado.');
    }
  }

  @override
  Future<void> eliminarFactura(int id) async {
    try {
      final res = await _cliente
          .delete(Uri.parse('${Constantes.urlBase}facturas/$id/'))
          .timeout(Constantes.timeout);
      if (res.statusCode != 204) {
        throw ExcepcionApi('Error al eliminar factura (${res.statusCode}).');
      }
    } on SocketException {
      throw const ExcepcionApi('Sin conexión a internet.');
    } on TimeoutException {
      throw const ExcepcionApi('La petición tardó demasiado.');
    }
  }
}
