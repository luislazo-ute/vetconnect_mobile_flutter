// Test de use case con mockito: el mock se genera sobre la INTERFAZ.
// Generar mocks: dart run build_runner build --delete-conflicting-outputs
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:vetconnect_app/data/dtos/pagina_dto.dart';
import 'package:vetconnect_app/domain/entities/servicio.dart';
import 'package:vetconnect_app/domain/repositories/i_servicio_repository.dart';
import 'package:vetconnect_app/domain/usecases/obtener_servicios_uc.dart';

import 'usecases_test.mocks.dart';

@GenerateMocks([IServicioRepository])
void main() {
  test('ObtenerServiciosUc delega en el repositorio', () async {
    final repo = MockIServicioRepository();
    final paginaEsperada = PaginaDto<Servicio>(
        count: 0, next: null, previous: null, results: const []);

    when(repo.obtenerServicios(
      pagina: anyNamed('pagina'),
      busqueda: anyNamed('busqueda'),
    )).thenAnswer((_) async => paginaEsperada);

    final uc = ObtenerServiciosUc(repo);
    final resultado = await uc(pagina: 2, busqueda: 'vac');

    expect(resultado, paginaEsperada);
    verify(repo.obtenerServicios(pagina: 2, busqueda: 'vac')).called(1);
  });
}
