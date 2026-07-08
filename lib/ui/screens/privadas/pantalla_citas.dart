import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errores.dart';
import '../../../core/tema.dart';
import '../../../domain/entities/cita.dart';
import '../../../domain/entities/rol.dart';
import '../../notifiers/citas_notifier.dart';
import '../../notifiers/citas_state.dart';
import '../../providers/cita_providers.dart';
import '../../providers/rol_provider.dart';
import 'pantalla_cita_formulario.dart';

class PantallaCitas extends ConsumerStatefulWidget {
  const PantallaCitas({super.key});

  @override
  ConsumerState<PantallaCitas> createState() => _PantallaCitasState();
}

class _PantallaCitasState extends ConsumerState<PantallaCitas> {
  final _scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollCtrl.addListener(() {
      final pos = _scrollCtrl.position;
      if (pos.pixels >= pos.maxScrollExtent - 200) {
        ref.read(citasNotifierProvider.notifier).cargarMas();
      }
    });
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  Future<void> _cambiarEstado(Cita c, String nuevo) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(cambiarEstadoCitaUcProvider)(c.id, nuevo);
      ref.read(citasNotifierProvider.notifier).cargar();
      messenger.showSnackBar(
        SnackBar(content: Text('Cita marcada como "$nuevo"')),
      );
    } on ExcepcionApi catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text(e.mensaje), backgroundColor: Colors.red),
      );
    }
  }

  Color _colorEstado(String estado) => switch (estado) {
    'pendiente' => Colors.amber.shade800,
    'confirmada' => Colors.blue.shade700,
    'completada' => TemaApp.verdeBosque,
    'cancelada' => Colors.red.shade400,
    _ => Colors.grey,
  };

  Widget _chipEstado(Cita c) {
    final color = _colorEstado(c.estado);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        c.estadoDisplay,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final estado = ref.watch(citasNotifierProvider);
    final rol = ref.watch(rolActualProvider);
    final puedeAgendar = rol == Rol.usuario || rol == Rol.admin;
    final puedeCambiar = rol == Rol.doctor || rol == Rol.admin;
    final textos = Theme.of(context).textTheme;

    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 12, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Citas',
                  style: textos.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (puedeAgendar)
                  TextButton.icon(
                    onPressed:
                        () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const PantallaCitaFormulario(),
                          ),
                        ),
                    icon: const Icon(Icons.add),
                    label: const Text('Agendar'),
                  ),
              ],
            ),
          ),
          Expanded(child: _construirLista(estado, puedeCambiar)),
        ],
      ),
    );
  }

  Widget _construirLista(CitasState estado, bool puedeCambiar) {
    if (estado.cargando) {
      return const Center(child: CircularProgressIndicator());
    }
    if (estado.error != null && estado.citas.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(estado.error!),
            const SizedBox(height: 12),
            FilledButton(
              onPressed:
                  () => ref.read(citasNotifierProvider.notifier).cargar(),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }
    if (estado.citas.isEmpty) {
      return const Center(child: Text('No hay citas.'));
    }
    return ListView.builder(
      controller: _scrollCtrl,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
      itemCount: estado.citas.length + (estado.cargandoMas ? 1 : 0),
      itemBuilder: (context, i) {
        if (i >= estado.citas.length) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        final c = estado.citas[i];
        return Card(
          child: ListTile(
            leading: const CircleAvatar(child: Icon(Icons.event)),
            title: Text(c.mascotaNombre),
            subtitle: Text('${c.fechaCorta} · ${c.horaCorta}\n${c.motivo}'),
            isThreeLine: true,
            trailing:
                puedeCambiar
                    ? PopupMenuButton<String>(
                      onSelected: (nuevo) => _cambiarEstado(c, nuevo),
                      itemBuilder:
                          (_) => const [
                            PopupMenuItem(
                              value: 'pendiente',
                              child: Text('Pendiente'),
                            ),
                            PopupMenuItem(
                              value: 'confirmada',
                              child: Text('Confirmada'),
                            ),
                            PopupMenuItem(
                              value: 'completada',
                              child: Text('Completada'),
                            ),
                            PopupMenuItem(
                              value: 'cancelada',
                              child: Text('Cancelada'),
                            ),
                          ],
                      child: _chipEstado(c),
                    )
                    : _chipEstado(c),
          ),
        );
      },
    );
  }
}
