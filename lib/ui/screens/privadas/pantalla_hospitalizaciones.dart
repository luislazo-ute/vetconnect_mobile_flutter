import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errores.dart';
import '../../../domain/entities/hospitalizacion.dart';
import '../../../domain/entities/rol.dart';
import '../../notifiers/hospitalizaciones_notifier.dart';
import '../../notifiers/hospitalizaciones_state.dart';
import '../../providers/hospitalizacion_providers.dart';
import '../../providers/rol_provider.dart';
import 'pantalla_hospitalizacion_detalle.dart';
import 'pantalla_hospitalizacion_formulario.dart';

class PantallaHospitalizaciones extends ConsumerStatefulWidget {
  const PantallaHospitalizaciones({super.key});

  @override
  ConsumerState<PantallaHospitalizaciones> createState() =>
      _PantallaHospitalizacionesState();
}

class _PantallaHospitalizacionesState
    extends ConsumerState<PantallaHospitalizaciones> {
  final _scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollCtrl.addListener(() {
      final pos = _scrollCtrl.position;
      if (pos.pixels >= pos.maxScrollExtent - 200) {
        ref.read(hospitalizacionesNotifierProvider.notifier).cargarMas();
      }
    });
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _abrirFormulario() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const PantallaHospitalizacionFormulario()),
    );
  }

  void _abrirDetalle(Hospitalizacion h) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PantallaHospitalizacionDetalle(hospitalizacion: h),
      ),
    );
  }

  Future<void> _confirmarEliminar(Hospitalizacion h) async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar hospitalización'),
        content: Text(
            '¿Seguro que quieres eliminar la hospitalización de "${h.mascotaNombre}"?'),
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
      await ref.read(eliminarHospitalizacionUcProvider)(h.id);
      ref.read(hospitalizacionesNotifierProvider.notifier).cargar();
      messenger.showSnackBar(
        const SnackBar(content: Text('Hospitalización eliminada')),
      );
    } on ExcepcionApi catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text(e.mensaje), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final estado = ref.watch(hospitalizacionesNotifierProvider);
    final esAdmin = ref.watch(rolActualProvider) == Rol.admin;
    final textos = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 12, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Hospitalizaciones',
                    style: textos.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  TextButton.icon(
                    onPressed: _abrirFormulario,
                    icon: const Icon(Icons.add),
                    label: const Text('Ingreso'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Buscar hospitalización...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (t) =>
                    ref.read(hospitalizacionesNotifierProvider.notifier).buscar(t),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(child: _construirLista(estado, esAdmin)),
          ],
        ),
      ),
    );
  }

  Widget _construirLista(HospitalizacionesState estado, bool esAdmin) {
    if (estado.cargando) return const Center(child: CircularProgressIndicator());

    if (estado.error != null && estado.hospitalizaciones.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(estado.error!),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () =>
                  ref.read(hospitalizacionesNotifierProvider.notifier).cargar(),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (estado.hospitalizaciones.isEmpty) {
      return const Center(child: Text('No hay hospitalizaciones.'));
    }

    return ListView.builder(
      controller: _scrollCtrl,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
      itemCount: estado.hospitalizaciones.length + (estado.cargandoMas ? 1 : 0),
      itemBuilder: (context, i) {
        if (i >= estado.hospitalizaciones.length) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        final h = estado.hospitalizaciones[i];
        final esHospitalizado = h.estado == 'hospitalizado';
        return Card(
          child: ListTile(
            onTap: () => _abrirDetalle(h),
            leading: CircleAvatar(
              backgroundColor:
                  esHospitalizado ? Colors.orange[100] : Colors.green[100],
              child: Icon(
                esHospitalizado ? Icons.local_hospital_outlined : Icons.check_circle,
                color: esHospitalizado ? Colors.orange : Colors.green,
              ),
            ),
            title: Text(h.mascotaNombre),
            subtitle: Text(
              '${h.motivo} · ${h.estadoDisplay}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: esAdmin
                ? PopupMenuButton<String>(
                    onSelected: (op) {
                      if (op == 'editar') _abrirDetalle(h);
                      if (op == 'eliminar') _confirmarEliminar(h);
                    },
                    itemBuilder: (_) => const [
                      PopupMenuItem(value: 'editar', child: Text('Editar')),
                      PopupMenuItem(value: 'eliminar', child: Text('Eliminar')),
                    ],
                  )
                : Chip(
                    label: Text(h.estadoDisplay),
                    backgroundColor: esHospitalizado
                        ? Colors.orange[100]
                        : Colors.green[100],
                  ),
          ),
        );
      },
    );
  }
}
