import '../repositories/i_notificacion_repository.dart';

class MarcarTodasNotificacionesLeidasUc {
  final INotificacionRepository _repo;
  MarcarTodasNotificacionesLeidasUc(this._repo);

  Future<void> call() => _repo.marcarTodasComoLeidas();
}
