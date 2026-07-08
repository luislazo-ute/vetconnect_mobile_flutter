import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../core/constantes.dart';
import '../../core/errores.dart';
import '../../domain/entities/tokens_auth.dart';
import '../../domain/entities/usuario.dart';
import '../../domain/repositories/i_auth_repository.dart';
import '../almacenamiento_tokens.dart';
import '../dtos/usuario_dto.dart';

class AuthRepositoryImpl implements IAuthRepository {
  final http.Client _cliente;
  final AlmacenamientoTokens _almacenamiento;

  AuthRepositoryImpl(this._cliente, this._almacenamiento);

  @override
  Future<(TokensAuth, Usuario)> iniciarSesion(
    String username,
    String password,
  ) async {
    final uri = Uri.parse('${Constantes.urlBase}token/');
    try {
      final respuesta = await _cliente
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'username': username, 'password': password}),
          )
          .timeout(Constantes.timeout);

      if (respuesta.statusCode == 200) {
        final json =
            jsonDecode(utf8.decode(respuesta.bodyBytes))
                as Map<String, dynamic>;
        final tokens = TokensAuth(
          access: json['access'] as String,
          refresh: json['refresh'] as String,
        );
        final usuario =
            UsuarioDto.fromJson(
              json['user'] as Map<String, dynamic>,
            ).toDomain();

        await _almacenamiento.guardar(tokens.access, tokens.refresh);

        return (tokens, usuario);
      }
      if (respuesta.statusCode == 401) {
        throw const ExcepcionApi('Usuario o contraseña incorrectos.');
      }
      throw ExcepcionApi('Error del servidor (${respuesta.statusCode}).');
    } on SocketException {
      throw const ExcepcionApi('Sin conexión a internet.');
    } on TimeoutException {
      throw const ExcepcionApi('La petición tardó demasiado.');
    } on FormatException {
      throw const ExcepcionApi('Respuesta inválida del servidor.');
    }
  }

  @override
  Future<TokensAuth> refrescarToken(String refresh) async {
    final uri = Uri.parse('${Constantes.urlBase}token/refresh/');
    try {
      final respuesta = await _cliente
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'refresh': refresh}),
          )
          .timeout(Constantes.timeout);

      if (respuesta.statusCode == 200) {
        final json =
            jsonDecode(utf8.decode(respuesta.bodyBytes))
                as Map<String, dynamic>;
        final tokens = TokensAuth(
          access: json['access'] as String,
          refresh: json['refresh'] as String? ?? refresh,
        );
        await _almacenamiento.guardar(tokens.access, tokens.refresh);
        return tokens;
      }
      throw const ExcepcionApi('Sesión expirada. Inicia sesión de nuevo.');
    } on SocketException {
      throw const ExcepcionApi('Sin conexión a internet.');
    } on TimeoutException {
      throw const ExcepcionApi('La petición tardó demasiado.');
    }
  }

  @override
  Future<void> cerrarSesion(String refresh) async {
    final uri = Uri.parse('${Constantes.urlBase}auth/logout/');
    await _cliente
        .post(
          uri,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'refresh': refresh}),
        )
        .timeout(Constantes.timeout)
        .then((_) {}, onError: (Object _) {});
    await _almacenamiento.borrar();
  }

  @override
  Future<Usuario> obtenerPerfil() async {
    final uri = Uri.parse('${Constantes.urlBase}users/profile/');
    final access = await _almacenamiento.leerAccess();
    try {
      final respuesta = await _cliente
          .get(uri, headers: {'Authorization': 'Bearer $access'})
          .timeout(Constantes.timeout);

      if (respuesta.statusCode == 200) {
        final json =
            jsonDecode(utf8.decode(respuesta.bodyBytes))
                as Map<String, dynamic>;
        return UsuarioDto.fromJson(json).toDomain();
      }
      throw const ExcepcionApi('No se pudo obtener el perfil.');
    } on SocketException {
      throw const ExcepcionApi('Sin conexión a internet.');
    } on TimeoutException {
      throw const ExcepcionApi('La petición tardó demasiado.');
    }
  }
}
