import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../core/constantes.dart';
import '../../core/errores.dart';
import '../../domain/entities/servicio.dart';
import '../../domain/repositories/i_servicio_repository.dart';
import '../dtos/pagina_dto.dart';
import '../dtos/servicio_dto.dart';

class ServicioRepositoryImpl implements IServicioRepository {
  final http.Client _cliente;

  ServicioRepositoryImpl(this._cliente);

  @override
  Future<PaginaDto<Servicio>> obtenerServicios({
    int pagina = 1,
    String busqueda = '',
  }) async {
    final uri = Uri.parse('${Constantes.urlBase}servicios/').replace(
      queryParameters: {
        'page': '$pagina',
        if (busqueda.isNotEmpty) 'search': busqueda,
      },
    );

    try {
      final respuesta = await _cliente.get(uri).timeout(Constantes.timeout);

      if (respuesta.statusCode == 200) {
        final json =
            jsonDecode(utf8.decode(respuesta.bodyBytes))
                as Map<String, dynamic>;

        return PaginaDto.fromJson(
          json,
          (item) => ServicioDto.fromJson(item).toDomain(),
        );
      }
      throw ExcepcionApi('Error del servidor (${respuesta.statusCode}).');
    } on SocketException {
      throw const ExcepcionApi('Sin conexión a internet.');
    } on TimeoutException {
      throw const ExcepcionApi(
        'La petición tardó demasiado. Intenta de nuevo.',
      );
    } on FormatException {
      throw const ExcepcionApi('Respuesta inválida del servidor.');
    }
  }
}
