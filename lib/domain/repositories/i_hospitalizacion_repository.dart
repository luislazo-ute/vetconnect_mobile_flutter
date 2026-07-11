import '../../data/dtos/pagina_dto.dart';
import '../entities/hospitalizacion.dart';

abstract interface class IHospitalizacionRepository {
  Future<PaginaDto<Hospitalizacion>> obtenerHospitalizaciones({
    int pagina = 1,
    String busqueda = '',
  });
  Future<Hospitalizacion> obtenerHospitalizacion(int id);
  Future<Hospitalizacion> crearHospitalizacion(Map<String, dynamic> datos);
  Future<Hospitalizacion> actualizarHospitalizacion(int id, Map<String, dynamic> datos);
  Future<void> eliminarHospitalizacion(int id);
}
