import '../repositories/i_notificacion_repository.dart';

class MarcarNotificacionLeidaUc {
  final INotificacionRepository _repo;
  MarcarNotificacionLeidaUc(this._repo);

  Future<void> call(int id) => _repo.marcarComoLeida(id);
}
