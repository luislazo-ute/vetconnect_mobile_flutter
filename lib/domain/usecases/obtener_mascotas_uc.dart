import '../../data/dtos/pagina_dto.dart';
import '../entities/mascota.dart';
import '../repositories/i_mascota_repository.dart';

/// Caso de uso: obtener mascotas paginadas.
class ObtenerMascotasUc {
  final IMascotaRepository _repo;
  ObtenerMascotasUc(this._repo);

  Future<PaginaDto<Mascota>> call({int pagina = 1, String busqueda = ''}) {
    return _repo.obtenerMascotas(pagina: pagina, busqueda: busqueda);
  }
}
