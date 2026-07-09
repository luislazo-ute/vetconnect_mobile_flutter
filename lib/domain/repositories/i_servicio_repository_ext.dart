import '../entities/servicio.dart';

// Extiende el repositorio de servicios base con operaciones de escritura (admin)
abstract interface class IServicioAdminRepository {
  Future<Servicio> crearServicio(Map<String, dynamic> datos);
  Future<Servicio> actualizarServicio(int id, Map<String, dynamic> datos);
  Future<void> eliminarServicio(int id);
}
