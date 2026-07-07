import '../entities/galeria_foto.dart';
import '../repositories/i_galeria_repository.dart';

class ObtenerGaleriaUc {
  final IGaleriaRepository _repo;
  ObtenerGaleriaUc(this._repo);

  Future<List<GaleriaFoto>> call() => _repo.obtenerGaleria();
}
