import '../../data/dtos/pagina_dto.dart';
import '../entities/mascota.dart';

abstract interface class IMascotaRepository {
  Future<PaginaDto<Mascota>> obtenerMascotas({
    int pagina = 1,
    String busqueda = '',
  });

  Future<void> crearMascota(Map<String, dynamic> datos);

  Future<void> actualizarMascota(int id, Map<String, dynamic> datos);

  Future<void> eliminarMascota(int id);
}
