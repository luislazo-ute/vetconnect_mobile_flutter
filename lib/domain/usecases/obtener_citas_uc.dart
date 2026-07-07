import '../../data/dtos/pagina_dto.dart';
import '../entities/cita.dart';
import '../repositories/i_cita_repository.dart';

class ObtenerCitasUc {
  final ICitaRepository _repo;
  ObtenerCitasUc(this._repo);

  Future<PaginaDto<Cita>> call({int pagina = 1, String busqueda = ''}) =>
      _repo.obtenerCitas(pagina: pagina, busqueda: busqueda);
}
