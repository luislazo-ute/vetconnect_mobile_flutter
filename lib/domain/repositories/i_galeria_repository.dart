import '../entities/galeria_foto.dart';

abstract interface class IGaleriaRepository {
  Future<List<GaleriaFoto>> obtenerGaleria();

  Future<void> crearFoto(Map<String, dynamic> datos);
}
