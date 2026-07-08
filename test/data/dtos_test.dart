import 'package:flutter_test/flutter_test.dart';

import 'package:vetconnect_app/data/dtos/galeria_foto_dto.dart';
import 'package:vetconnect_app/data/dtos/mascota_dto.dart';
import 'package:vetconnect_app/data/dtos/pagina_dto.dart';
import 'package:vetconnect_app/data/dtos/servicio_dto.dart';
import 'package:vetconnect_app/domain/entities/servicio.dart';

void main() {
  test('ServicioDto: precio string "25.00" -> double en la entidad', () {
    final dto = ServicioDto.fromJson({
      'id': 1,
      'nombre': 'Consulta',
      'descripcion': 'Revisión',
      'precio': '25.00',
      'duracion_minutos': 30,
      'is_active': true,
    });
    final servicio = dto.toDomain();
    expect(servicio.precio, 25.0);
    expect(servicio.precioFormateado, r'$25.00');
  });

  test('MascotaDto: peso null se maneja sin romper', () {
    final dto = MascotaDto.fromJson({
      'id': 1,
      'nombre': 'Michi',
      'especie': 'gato',
      'especie_display': 'Gato',
      'raza': '',
      'fecha_nacimiento': null,
      'peso': null,
      'cliente': 5,
      'cliente_nombre': 'cliente1',
      'is_active': true,
    });
    expect(dto.toDomain().peso, isNull);
  });

  test('PaginaDto genérico: hayMas depende de next', () {
    final pagina = PaginaDto<Servicio>.fromJson({
      'count': 1,
      'next': 'http://x/?page=2',
      'previous': null,
      'results': [
        {
          'id': 1,
          'nombre': 'S',
          'descripcion': '',
          'precio': '10.00',
          'duracion_minutos': 30,
          'is_active': true,
        },
      ],
    }, (item) => ServicioDto.fromJson(item).toDomain());

    expect(pagina.count, 1);
    expect(pagina.hayMas, true);
    expect(pagina.results.first.nombre, 'S');
  });

  test('GaleriaFotoDto: extrae url del array `fotos` si no está arriba', () {
    final dto = GaleriaFotoDto.fromJson({
      '_id': 'abc123',
      'mascota_id': 1,
      'descripcion': 'control',
      'fotos': [
        {'url': 'https://ej.com/a.jpg', 'descripcion': 'x'},
      ],
    });
    expect(dto.url, 'https://ej.com/a.jpg');
    expect(dto.id, 'abc123');
  });
}
