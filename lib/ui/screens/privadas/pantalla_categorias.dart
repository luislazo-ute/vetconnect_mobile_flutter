import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errores.dart';
import '../../../domain/entities/categoria_producto.dart';
import '../../../domain/entities/rol.dart';
import '../../notifiers/categorias_notifier.dart';
import '../../notifiers/categorias_state.dart';
import '../../providers/categoria_providers.dart';
import '../../providers/rol_provider.dart';
import 'pantalla_categoria_detalle.dart';
import 'pantalla_categoria_formulario.dart';

class PantallaCategorias extends ConsumerStatefulWidget {
  const PantallaCategorias({super.key});

  @override
  ConsumerState<PantallaCategorias> createState() => _PantallaCategoriasState();
}

class _PantallaCategoriasState extends ConsumerState<PantallaCategorias> {
  final _scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollCtrl.addListener(() {
      final pos = _scrollCtrl.position;
      if (pos.pixels >= pos.maxScrollExtent - 200) {
        ref.read(categoriasNotifierProvider.notifier).cargarMas();
      }
    });
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _abrirFormulario([CategoriaProducto? c]) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => PantallaCategoriaFormulario(categoria: c)),
    );
  }

  void _abrirDetalle(CategoriaProducto c) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => PantallaCategoriaDetalle(categoria: c)),
    );
  }

  Future<void> _confirmarEliminar(CategoriaProducto c) async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar categoría'),
        content: Text('¿Seguro que quieres eliminar "${c.nombre}"?'),
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
      await ref.read(eliminarCategoriaUcProvider)(c.id);
      ref.read(categoriasNotifierProvider.notifier).cargar();
      messenger.showSnackBar(
        const SnackBar(content: Text('Categoría eliminada')),
      );
    } on ExcepcionApi catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text(e.mensaje), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final estado = ref.watch(categoriasNotifierProvider);
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
                    'Categorías',
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
                  hintText: 'Buscar categoría...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (t) =>
                    ref.read(categoriasNotifierProvider.notifier).buscar(t),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(child: _construirLista(estado, esAdmin)),
          ],
        ),
      ),
    );
  }

  Widget _construirLista(CategoriasState estado, bool esAdmin) {
    if (estado.cargando) return const Center(child: CircularProgressIndicator());

    if (estado.error != null && estado.categorias.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(estado.error!),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () => ref.read(categoriasNotifierProvider.notifier).cargar(),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (estado.categorias.isEmpty) {
      return const Center(child: Text('No hay categorías.'));
    }

    return ListView.builder(
      controller: _scrollCtrl,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
      itemCount: estado.categorias.length + (estado.cargandoMas ? 1 : 0),
      itemBuilder: (context, i) {
        if (i >= estado.categorias.length) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        final c = estado.categorias[i];
        return Card(
          child: ListTile(
            onTap: () => _abrirDetalle(c),
            leading: const CircleAvatar(child: Icon(Icons.category)),
            title: Text(c.nombre),
            subtitle: Text(c.descripcion.isNotEmpty ? c.descripcion : 'Sin descripción'),
            trailing: esAdmin
                ? PopupMenuButton<String>(
                    onSelected: (op) {
                      if (op == 'editar') _abrirFormulario(c);
                      if (op == 'eliminar') _confirmarEliminar(c);
                    },
                    itemBuilder: (_) => const [
                      PopupMenuItem(value: 'editar', child: Text('Editar')),
                      PopupMenuItem(value: 'eliminar', child: Text('Eliminar')),
                    ],
                  )
                : Chip(
                    label: Text(c.isActive ? 'Activo' : 'Inactivo'),
                    backgroundColor: c.isActive ? Colors.green[100] : Colors.grey[200],
                  ),
          ),
        );
      },
    );
  }
}
