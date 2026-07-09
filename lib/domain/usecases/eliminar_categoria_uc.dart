import '../repositories/i_categoria_producto_repository.dart';

class EliminarCategoriaUc {
  final ICategoriaProductoRepository _repo;
  EliminarCategoriaUc(this._repo);

  Future<void> call(int id) => _repo.eliminarCategoria(id);
}
