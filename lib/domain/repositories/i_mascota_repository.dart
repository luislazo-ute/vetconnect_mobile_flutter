import '../../data/dtos/pagina_dto.dart';
import '../entities/mascota.dart';

/// Contrato del repositorio de mascotas (lectura + escritura).
abstract interface class IMascotaRepository {
  Future<PaginaDto<Mascota>> obtenerMascotas({int pagina = 1, String busqueda = ''});

  /// Crea una mascota. `datos` es el cuerpo JSON (nombre, especie, cliente, ...).
  Future<void> crearMascota(Map<String, dynamic> datos);

  /// Actualiza la mascota `id` con los campos de `datos`.
  Future<void> actualizarMascota(int id, Map<String, dynamic> datos);

  /// Elimina la mascota `id`.
  Future<void> eliminarMascota(int id);
}
