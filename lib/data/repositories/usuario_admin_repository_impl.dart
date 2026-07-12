import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../core/constantes.dart';
import '../../core/errores.dart';
import '../../domain/repositories/i_usuario_admin_repository.dart';

class UsuarioAdminRepositoryImpl implements IUsuarioAdminRepository {
  final http.Client _cliente;
  UsuarioAdminRepositoryImpl(this._cliente);

  static const _headers = {'Content-Type': 'application/json'};

  @override
  Future<int> crearUsuario(Map<String, dynamic> datos) async {
    final uri = Uri.parse('${Constantes.urlBase}users/');
    try {
      final r = await _cliente
          .post(uri, headers: _headers, body: jsonEncode(datos))
          .timeout(Constantes.timeout);
      if (r.statusCode == 201) {
        final json = jsonDecode(utf8.decode(r.bodyBytes)) as Map<String, dynamic>;
        return json['id'] as int;
      }
      throw ExcepcionApi(_mensajeError(r));
    } on SocketException {
      throw const ExcepcionApi('Sin conexión a internet.');
    } on TimeoutException {
      throw const ExcepcionApi('La petición tardó demasiado.');
    }
  }

  String _mensajeError(http.Response r) {
    if (r.statusCode == 403) return 'No tienes permiso para crear usuarios.';
    if (r.statusCode == 400) {
      // El backend devuelve los errores de validación por campo.
      try {
        final json = jsonDecode(utf8.decode(r.bodyBytes)) as Map<String, dynamic>;
        final primero = json.values.first;
        final texto = primero is List ? primero.first : primero;
        return texto.toString();
      } catch (_) {
        return 'Datos inválidos.';
      }
    }
    return 'Error del servidor (${r.statusCode}).';
  }
}
