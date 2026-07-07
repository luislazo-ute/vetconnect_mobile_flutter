import '../repositories/i_galeria_repository.dart';

class CrearFotoUc {
  final IGaleriaRepository _repo;
  CrearFotoUc(this._repo);

  Future<void> call(Map<String, dynamic> datos) => _repo.crearFoto(datos);
}
