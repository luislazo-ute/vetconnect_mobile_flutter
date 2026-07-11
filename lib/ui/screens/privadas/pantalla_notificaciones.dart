import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/rol.dart';
import '../../notifiers/notificaciones_notifier.dart';
import '../../notifiers/notificaciones_state.dart';
import '../../providers/rol_provider.dart';

class PantallaNotificaciones extends ConsumerStatefulWidget {
  const PantallaNotificaciones({super.key});

  @override
  ConsumerState<PantallaNotificaciones> createState() =>
      _PantallaNotificacionesState();
}

class _PantallaNotificacionesState
    extends ConsumerState<PantallaNotificaciones> {
  final _scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollCtrl.addListener(() {
      final pos = _scrollCtrl.position;
      if (pos.pixels >= pos.maxScrollExtent - 200) {
        ref.read(notificacionesNotifierProvider.notifier).cargarMas();
      }
    });
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final estado = ref.watch(notificacionesNotifierProvider);
    final esAdmin = ref.watch(rolActualProvider) == Rol.admin;
    final textos = Theme.of(context).textTheme;
    final noLeidas = estado.notificaciones.where((n) => !n.leida).length;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 12, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        'Notificaciones',
                        style: textos.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold),
                      ),
                      if (noLeidas > 0) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '$noLeidas',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 12),
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (noLeidas > 0)
                    TextButton(
                      onPressed: () => ref
                          .read(notificacionesNotifierProvider.notifier)
                          .marcarTodasLeidas(),
                      child: const Text('Leer todas'),
                    ),
                ],
              ),
            ),
            Expanded(child: _construirLista(estado, esAdmin)),
          ],
        ),
      ),
    );
  }

  Widget _construirLista(NotificacionesState estado, bool esAdmin) {
    if (estado.cargando) return const Center(child: CircularProgressIndicator());

    if (estado.error != null && estado.notificaciones.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(estado.error!),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () =>
                  ref.read(notificacionesNotifierProvider.notifier).cargar(),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (estado.notificaciones.isEmpty) {
      return const Center(child: Text('No hay notificaciones.'));
    }

    return ListView.builder(
      controller: _scrollCtrl,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
      itemCount: estado.notificaciones.length + (estado.cargandoMas ? 1 : 0),
      itemBuilder: (context, i) {
        if (i >= estado.notificaciones.length) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        final n = estado.notificaciones[i];
        return Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: n.leida ? Colors.grey[200] : Colors.blue[100],
              child: Icon(
                n.leida ? Icons.notifications_none : Icons.notifications_active,
                color: n.leida ? Colors.grey : Colors.blue,
              ),
            ),
            title: Text(
              n.titulo,
              style: TextStyle(
                fontWeight: n.leida ? FontWeight.normal : FontWeight.bold,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(n.mensaje, maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Text(
                  n.fechaCreacion,
                  style: TextStyle(
                    fontSize: 11,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            trailing: n.leida
                ? null
                : TextButton(
                    onPressed: () => ref
                        .read(notificacionesNotifierProvider.notifier)
                        .marcarLeida(n.id),
                    child: const Text('Leída'),
                  ),
          ),
        );
      },
    );
  }
}
