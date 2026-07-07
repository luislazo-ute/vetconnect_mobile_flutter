import '../entities/galeria_foto.dart';

/// Contrato de la galería de mascotas (MongoDB, lista plana sin paginación).
abstract interface class IGaleriaRepository {
  Future<List<GaleriaFoto>> obtenerGaleria();

  /// Crea una foto (solo ADMIN). `datos` = cuerpo JSON.
  Future<void> crearFoto(Map<String, dynamic> datos);
}
