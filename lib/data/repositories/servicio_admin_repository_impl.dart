import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../core/constantes.dart';
import '../../core/errores.dart';
import '../../domain/entities/servicio.dart';
import '../../domain/repositories/i_servicio_repository_ext.dart';
import '../dtos/servicio_dto.dart';

class ServicioAdminRepositoryImpl implements IServicioAdminRepository {
  final http.Client _cliente;
  ServicioAdminRepositoryImpl(this._cliente);

  Map<String, String> get _headers => {'Content-Type': 'application/json'};

  @override
  Future<Servicio> crearServicio(Map<String, dynamic> datos) async {
    try {
      final res = await _cliente
          .post(
            Uri.parse('${Constantes.urlBase}servicios/'),
            headers: _headers,
            body: jsonEncode(datos),
          )
          .timeout(Constantes.timeout);
      if (res.statusCode == 201) {
        return ServicioDto.fromJson(
          jsonDecode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>,
        ).toDomain();
      }
      throw ExcepcionApi('Error al crear servicio (${res.statusCode}).');
    } on SocketException {
      throw const ExcepcionApi('Sin conexión a internet.');
    } on TimeoutException {
      throw const ExcepcionApi('La petición tardó demasiado.');
    }
  }

  @override
  Future<Servicio> actualizarServicio(int id, Map<String, dynamic> datos) async {
    try {
      final res = await _cliente
          .patch(
            Uri.parse('${Constantes.urlBase}servicios/$id/'),
            headers: _headers,
            body: jsonEncode(datos),
          )
          .timeout(Constantes.timeout);
      if (res.statusCode == 200) {
        return ServicioDto.fromJson(
          jsonDecode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>,
        ).toDomain();
      }
      throw ExcepcionApi('Error al actualizar servicio (${res.statusCode}).');
    } on SocketException {
      throw const ExcepcionApi('Sin conexión a internet.');
    } on TimeoutException {
      throw const ExcepcionApi('La petición tardó demasiado.');
    }
  }

  @override
  Future<void> eliminarServicio(int id) async {
    try {
      final res = await _cliente
          .delete(Uri.parse('${Constantes.urlBase}servicios/$id/'))
          .timeout(Constantes.timeout);
      if (res.statusCode != 204) {
        throw ExcepcionApi('Error al eliminar servicio (${res.statusCode}).');
      }
    } on SocketException {
      throw const ExcepcionApi('Sin conexión a internet.');
    } on TimeoutException {
      throw const ExcepcionApi('La petición tardó demasiado.');
    }
  }
}
