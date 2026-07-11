import '../../data/dtos/pagina_dto.dart';
import '../entities/vacuna.dart';
import '../repositories/i_vacuna_repository.dart';

class ObtenerVacunasUc {
  final IVacunaRepository _repo;
  ObtenerVacunasUc(this._repo);

  Future<PaginaDto<Vacuna>> call({int pagina = 1, String busqueda = ''}) {
    return _repo.obtenerVacunas(pagina: pagina, busqueda: busqueda);
  }
}
