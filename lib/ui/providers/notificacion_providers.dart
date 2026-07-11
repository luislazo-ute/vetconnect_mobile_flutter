import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/notificacion_repository_impl.dart';
import '../../domain/repositories/i_notificacion_repository.dart';
import '../../domain/usecases/marcar_notificacion_leida_uc.dart';
import '../../domain/usecases/marcar_todas_notificaciones_leidas_uc.dart';
import '../../domain/usecases/obtener_notificaciones_uc.dart';
import 'cliente_autenticado_provider.dart';

final notificacionRepositoryProvider = Provider<INotificacionRepository>((ref) {
  return NotificacionRepositoryImpl(ref.watch(clienteAutenticadoProvider));
});

final obtenerNotificacionesUcProvider = Provider(
  (ref) => ObtenerNotificacionesUc(ref.watch(notificacionRepositoryProvider)),
);
final marcarNotificacionLeidaUcProvider = Provider(
  (ref) => MarcarNotificacionLeidaUc(ref.watch(notificacionRepositoryProvider)),
);
final marcarTodasNotificacionesLeidasUcProvider = Provider(
  (ref) =>
      MarcarTodasNotificacionesLeidasUc(ref.watch(notificacionRepositoryProvider)),
);
