import 'dart:async';   // TimeoutException
import 'dart:convert'; // jsonDecode, utf8
import 'dart:io';      // SocketException

import 'package:http/http.dart' as http;

import '../../core/constantes.dart';
import '../../core/errores.dart';
import '../../domain/entities/servicio.dart';
import '../../domain/repositories/i_servicio_repository.dart';
import '../dtos/pagina_dto.dart';
import '../dtos/servicio_dto.dart';

/// Implementación real del repositorio de servicios: aquí SÍ hay http.
class ServicioRepositoryImpl implements IServicioRepository {
  final http.Client _cliente;

  ServicioRepositoryImpl(this._cliente);

  @override
  Future<PaginaDto<Servicio>> obtenerServicios({
    int pagina = 1,
    String busqueda = '',
  }) async {
    // 1) URL: .../servicios/?page=1&search=...
    final uri = Uri.parse('${Constantes.urlBase}servicios/').replace(
      queryParameters: {
        'page': '$pagina',
        if (busqueda.isNotEmpty) 'search': busqueda,
      },
    );

    try {
      // 2) GET con timeout de 15s.
      final respuesta = await _cliente.get(uri).timeout(Constantes.timeout);

      // 3) Éxito → decodificar (utf8 por los acentos) y convertir.
      if (respuesta.statusCode == 200) {
        final json =
            jsonDecode(utf8.decode(respuesta.bodyBytes)) as Map<String, dynamic>;

        // Conecta TODO: PaginaDto genérico + DTO + entity.
        return PaginaDto.fromJson(
          json,
          // COMPLETAR: la función que convierte cada item a Servicio.
          // Pista: (item) => ServicioDto.fromJson(item).toDomain()
          (item) => ServicioDto.fromJson(item).toDomain(),
        );
      }
      // 4) Otro código = error.
      throw ExcepcionApi('Error del servidor (${respuesta.statusCode}).');
    } on SocketException {
      throw const ExcepcionApi('Sin conexión a internet.');
    } on TimeoutException {
      throw const ExcepcionApi('La petición tardó demasiado. Intenta de nuevo.');
    } on FormatException {
      throw const ExcepcionApi('Respuesta inválida del servidor.');
    }
  }
}
