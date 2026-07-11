import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errores.dart';
import '../../../domain/entities/rol.dart';
import '../../../domain/entities/vacuna.dart';
import '../../notifiers/vacunas_notifier.dart';
import '../../notifiers/vacunas_state.dart';
import '../../providers/rol_provider.dart';
import '../../providers/vacuna_providers.dart';
import 'pantalla_vacuna_detalle.dart';
import 'pantalla_vacuna_formulario.dart';

class PantallaVacunas extends ConsumerStatefulWidget {
  const PantallaVacunas({super.key});

  @override
  ConsumerState<PantallaVacunas> createState() => _PantallaVacunasState();
}

class _PantallaVacunasState extends ConsumerState<PantallaVacunas> {
  final _scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollCtrl.addListener(() {
      final pos = _scrollCtrl.position;
      if (pos.pixels >= pos.maxScrollExtent - 200) {
        ref.read(vacunasNotifierProvider.notifier).cargarMas();
      }
    });
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _abrirFormulario([Vacuna? v]) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => PantallaVacunaFormulario(vacuna: v)),
    );
  }

  void _abrirDetalle(Vacuna v) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => PantallaVacunaDetalle(vacuna: v)),
    );
  }

  Future<void> _confirmarEliminar(Vacuna v) async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar vacuna'),
        content: Text('¿Seguro que quieres eliminar "${v.nombreVacuna}"?'),
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
      await ref.read(eliminarVacunaUcProvider)(v.id);
      ref.read(vacunasNotifierProvider.notifier).cargar();
      messenger.showSnackBar(
        const SnackBar(content: Text('Vacuna eliminada')),
      );
    } on ExcepcionApi catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text(e.mensaje), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final estado = ref.watch(vacunasNotifierProvider);
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
                    'Vacunas',
                    style: textos.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  if (esAdmin)
                    TextButton.icon(
                      onPressed: () => _abrirFormulario(),
                      icon: const Icon(Icons.add),
                      label: const Text('Agregar'),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Buscar vacuna...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (t) =>
                    ref.read(vacunasNotifierProvider.notifier).buscar(t),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(child: _construirLista(estado, esAdmin)),
          ],
        ),
      ),
    );
  }

  Widget _construirLista(VacunasState estado, bool esAdmin) {
    if (estado.cargando) return const Center(child: CircularProgressIndicator());

    if (estado.error != null && estado.vacunas.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(estado.error!),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () => ref.read(vacunasNotifierProvider.notifier).cargar(),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (estado.vacunas.isEmpty) {
      return const Center(child: Text('No hay vacunas registradas.'));
    }

    return ListView.builder(
      controller: _scrollCtrl,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
      itemCount: estado.vacunas.length + (estado.cargandoMas ? 1 : 0),
      itemBuilder: (context, i) {
        if (i >= estado.vacunas.length) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        final v = estado.vacunas[i];
        return Card(
          child: ListTile(
            onTap: () => _abrirDetalle(v),
            leading: const CircleAvatar(child: Icon(Icons.vaccines_outlined)),
            title: Text(v.nombreVacuna),
            subtitle: Text('${v.mascotaNombre} · ${v.fechaAplicacion}'),
            trailing: esAdmin
                ? PopupMenuButton<String>(
                    onSelected: (op) {
                      if (op == 'editar') _abrirFormulario(v);
                      if (op == 'eliminar') _confirmarEliminar(v);
                    },
                    itemBuilder: (_) => const [
                      PopupMenuItem(value: 'editar', child: Text('Editar')),
                      PopupMenuItem(value: 'eliminar', child: Text('Eliminar')),
                    ],
                  )
                : Chip(
                    label: Text(v.isActive ? 'Activa' : 'Inactiva'),
                    backgroundColor:
                        v.isActive ? Colors.green[100] : Colors.grey[200],
                  ),
          ),
        );
      },
    );
  }
}
