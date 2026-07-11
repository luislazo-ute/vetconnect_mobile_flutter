import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errores.dart';
import '../../../domain/entities/receta.dart';
import '../../../domain/entities/rol.dart';
import '../../notifiers/recetas_notifier.dart';
import '../../notifiers/recetas_state.dart';
import '../../providers/receta_providers.dart';
import '../../providers/rol_provider.dart';
import 'pantalla_receta_detalle.dart';
import 'pantalla_receta_formulario.dart';

class PantallaRecetas extends ConsumerStatefulWidget {
  const PantallaRecetas({super.key});

  @override
  ConsumerState<PantallaRecetas> createState() => _PantallaRecetasState();
}

class _PantallaRecetasState extends ConsumerState<PantallaRecetas> {
  final _scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollCtrl.addListener(() {
      final pos = _scrollCtrl.position;
      if (pos.pixels >= pos.maxScrollExtent - 200) {
        ref.read(recetasNotifierProvider.notifier).cargarMas();
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
      MaterialPageRoute(builder: (_) => const PantallaRecetaFormulario()),
    );
  }

  void _abrirDetalle(Receta r) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => PantallaRecetaDetalle(recetaId: r.id)),
    );
  }

  Future<void> _confirmarEliminar(Receta r) async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar receta'),
        content: Text(
            '¿Seguro que quieres eliminar la receta de "${r.mascotaNombre}"?'),
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
      await ref.read(eliminarRecetaUcProvider)(r.id);
      ref.read(recetasNotifierProvider.notifier).cargar();
      messenger.showSnackBar(
        const SnackBar(content: Text('Receta eliminada')),
      );
    } on ExcepcionApi catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text(e.mensaje), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final estado = ref.watch(recetasNotifierProvider);
    final esAdmin = ref.watch(rolActualProvider) == Rol.admin;
    final textos = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: BackButton(),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 12, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recetas',
                    style: textos.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  if (esAdmin)
                    TextButton.icon(
                      onPressed: _abrirFormulario,
                      icon: const Icon(Icons.add),
                      label: const Text('Nueva'),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Buscar receta...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (t) =>
                    ref.read(recetasNotifierProvider.notifier).buscar(t),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(child: _construirLista(estado, esAdmin)),
          ],
        ),
      ),
    );
  }

  Widget _construirLista(RecetasState estado, bool esAdmin) {
    if (estado.cargando) return const Center(child: CircularProgressIndicator());

    if (estado.error != null && estado.recetas.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(estado.error!),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () => ref.read(recetasNotifierProvider.notifier).cargar(),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (estado.recetas.isEmpty) {
      return const Center(child: Text('No hay recetas.'));
    }

    return ListView.builder(
      controller: _scrollCtrl,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
      itemCount: estado.recetas.length + (estado.cargandoMas ? 1 : 0),
      itemBuilder: (context, i) {
        if (i >= estado.recetas.length) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        final r = estado.recetas[i];
        return Card(
          child: ListTile(
            onTap: () => _abrirDetalle(r),
            leading: const CircleAvatar(child: Icon(Icons.medication_outlined)),
            title: Text(r.mascotaNombre),
            subtitle: Text('${r.veterinarioNombre} · ${r.fecha}'),
            trailing: esAdmin
                ? PopupMenuButton<String>(
                    onSelected: (op) {
                      if (op == 'eliminar') _confirmarEliminar(r);
                    },
                    itemBuilder: (_) => const [
                      PopupMenuItem(value: 'eliminar', child: Text('Eliminar')),
                    ],
                  )
                : const Icon(Icons.chevron_right),
          ),
        );
      },
    );
  }
}
