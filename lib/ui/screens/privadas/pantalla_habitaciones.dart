import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errores.dart';
import '../../../domain/entities/habitacion.dart';
import '../../../domain/entities/rol.dart';
import '../../notifiers/habitaciones_notifier.dart';
import '../../providers/habitacion_providers.dart';
import '../../providers/rol_provider.dart';
import 'pantalla_habitacion_formulario.dart';

class PantallaHabitaciones extends ConsumerStatefulWidget {
  const PantallaHabitaciones({super.key});

  @override
  ConsumerState<PantallaHabitaciones> createState() =>
      _PantallaHabitacionesState();
}

class _PantallaHabitacionesState extends ConsumerState<PantallaHabitaciones> {
  final _scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollCtrl.addListener(() {
      final pos = _scrollCtrl.position;
      if (pos.pixels >= pos.maxScrollExtent - 200) {
        ref.read(habitacionesNotifierProvider.notifier).cargarMas();
      }
    });
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _abrirFormulario([Habitacion? h]) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => PantallaHabitacionFormulario(habitacion: h)),
    );
  }

  Future<void> _confirmarEliminar(Habitacion h) async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar habitación'),
        content: Text('¿Seguro que quieres eliminar la habitación "${h.codigo}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (confirmado != true) return;
    if (!mounted) return;

    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(eliminarHabitacionUcProvider)(h.id);
      ref.read(habitacionesNotifierProvider.notifier).cargar();
      messenger.showSnackBar(
        const SnackBar(content: Text('Habitación eliminada')),
      );
    } on ExcepcionApi catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text(e.mensaje), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final estado = ref.watch(habitacionesNotifierProvider);
    final esAdmin = ref.watch(rolActualProvider) == Rol.admin;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Habitaciones'),
        actions: [
          if (esAdmin)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => _abrirFormulario(),
            ),
        ],
      ),
      body: estado.cargando
          ? const Center(child: CircularProgressIndicator())
          : estado.error != null && estado.habitaciones.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(estado.error!),
                      const SizedBox(height: 12),
                      FilledButton(
                        onPressed: () =>
                            ref.read(habitacionesNotifierProvider.notifier).cargar(),
                        child: const Text('Reintentar'),
                      ),
                    ],
                  ),
                )
              : estado.habitaciones.isEmpty
                  ? const Center(child: Text('No hay habitaciones.'))
                  : ListView.builder(
                      controller: _scrollCtrl,
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
                      itemCount:
                          estado.habitaciones.length + (estado.cargandoMas ? 1 : 0),
                      itemBuilder: (context, i) {
                        if (i >= estado.habitaciones.length) {
                          return const Padding(
                            padding: EdgeInsets.all(16),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        final h = estado.habitaciones[i];
                        return Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: h.disponible
                                  ? Colors.green[100]
                                  : Colors.grey[200],
                              child: Icon(
                                Icons.meeting_room_outlined,
                                color: h.disponible ? Colors.green : Colors.grey,
                              ),
                            ),
                            title: Text('Habitación ${h.codigo}'),
                            subtitle: Text(
                              '${h.tipoDisplay} · Cap: ${h.capacidad} · \$${h.precioDia}',
                            ),
                            trailing: esAdmin
                                ? PopupMenuButton<String>(
                                    onSelected: (op) {
                                      if (op == 'editar') _abrirFormulario(h);
                                      if (op == 'eliminar') _confirmarEliminar(h);
                                    },
                                    itemBuilder: (_) => const [
                                      PopupMenuItem(
                                          value: 'editar', child: Text('Editar')),
                                      PopupMenuItem(
                                          value: 'eliminar', child: Text('Eliminar')),
                                    ],
                                  )
                                : Chip(
                                    label: Text(h.disponible ? 'Disponible' : 'Ocupada'),
                                    backgroundColor: h.disponible
                                        ? Colors.green[100]
                                        : Colors.grey[200],
                                  ),
                          ),
                        );
                      },
                    ),
    );
  }
}
