import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/errores.dart';
import '../../domain/entities/notificacion.dart';
import '../../domain/usecases/marcar_notificacion_leida_uc.dart';
import '../../domain/usecases/marcar_todas_notificaciones_leidas_uc.dart';
import '../../domain/usecases/obtener_notificaciones_uc.dart';
import '../providers/notificacion_providers.dart';
import 'notificaciones_state.dart';

class NotificacionesNotifier extends Notifier<NotificacionesState> {
  late final ObtenerNotificacionesUc _obtenerNotificaciones;
  late final MarcarNotificacionLeidaUc _marcarLeida;
  late final MarcarTodasNotificacionesLeidasUc _marcarTodas;

  @override
  NotificacionesState build() {
    _obtenerNotificaciones = ref.read(obtenerNotificacionesUcProvider);
    _marcarLeida = ref.read(marcarNotificacionLeidaUcProvider);
    _marcarTodas = ref.read(marcarTodasNotificacionesLeidasUcProvider);
    Future.microtask(cargar);
    return const NotificacionesState(cargando: true);
  }

  Future<void> cargar() async {
    state = state.copyWith(cargando: true, limpiarError: true);
    try {
      final pagina = await _obtenerNotificaciones(
        pagina: 1,
        busqueda: state.busqueda,
      );
      state = state.copyWith(
        notificaciones: pagina.results,
        cargando: false,
        hayMas: pagina.hayMas,
        paginaActual: 1,
      );
    } on ExcepcionApi catch (e) {
      state = state.copyWith(cargando: false, error: e.mensaje);
    }
  }

  Future<void> cargarMas() async {
    if (state.cargandoMas || !state.hayMas) return;
    state = state.copyWith(cargandoMas: true);
    try {
      final siguiente = state.paginaActual + 1;
      final pagina = await _obtenerNotificaciones(
        pagina: siguiente,
        busqueda: state.busqueda,
      );
      state = state.copyWith(
        notificaciones: [...state.notificaciones, ...pagina.results],
        cargandoMas: false,
        hayMas: pagina.hayMas,
        paginaActual: siguiente,
      );
    } on ExcepcionApi catch (e) {
      state = state.copyWith(cargandoMas: false, error: e.mensaje);
    }
  }

  Future<void> marcarLeida(int id) async {
    try {
      await _marcarLeida(id);
      final notifs = state.notificaciones.map((n) {
        if (n.id == id) {
          return Notificacion(
            id: n.id,
            titulo: n.titulo,
            mensaje: n.mensaje,
            leida: true,
            fechaCreacion: n.fechaCreacion,
          );
        }
        return n;
      }).toList();
      state = state.copyWith(notificaciones: notifs);
    } on ExcepcionApi {
      // Silently fail for mark as read
    }
  }

  Future<void> marcarTodasLeidas() async {
    try {
      await _marcarTodas();
      await cargar();
    } on ExcepcionApi {
      // Silently fail
    }
  }
}

final notificacionesNotifierProvider =
    NotifierProvider<NotificacionesNotifier, NotificacionesState>(
  NotificacionesNotifier.new,
);
