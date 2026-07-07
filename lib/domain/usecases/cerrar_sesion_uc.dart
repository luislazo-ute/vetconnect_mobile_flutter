import '../repositories/i_auth_repository.dart';

class CerrarSesionUc {
  final IAuthRepository _repo;
  CerrarSesionUc(this._repo);

  Future<void> call(String refresh) {
    // COMPLETAR: delega en _repo.cerrarSesion(refresh);
    return _repo.cerrarSesion(refresh);
  }
}
    