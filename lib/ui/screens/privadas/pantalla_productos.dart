import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errores.dart';
import '../../../domain/entities/producto.dart';
import '../../../domain/entities/rol.dart';
import '../../notifiers/productos_notifier.dart';
import '../../notifiers/productos_state.dart';
import '../../providers/producto_providers.dart';
import '../../providers/rol_provider.dart';
import 'pantalla_producto_detalle.dart';
import 'pantalla_producto_formulario.dart';

class PantallaProductos extends ConsumerStatefulWidget {
  const PantallaProductos({super.key});

  @override
  ConsumerState<PantallaProductos> createState() => _PantallaProductosState();
}

class _PantallaProductosState extends ConsumerState<PantallaProductos> {
  final _scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollCtrl.addListener(() {
      final pos = _scrollCtrl.position;
      if (pos.pixels >= pos.maxScrollExtent - 200) {
        ref.read(productosNotifierProvider.notifier).cargarMas();
      }
    });
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _abrirFormulario([Producto? p]) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => PantallaProductoFormulario(producto: p)),
    );
  }

  Future<void> _confirmarEliminar(Producto p) async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar producto'),
        content: Text('¿Seguro que quieres eliminar "${p.nombre}"?'),
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
      await ref.read(eliminarProductoUcProvider)(p.id);
      ref.read(productosNotifierProvider.notifier).cargar();
      messenger.showSnackBar(
        const SnackBar(content: Text('Producto eliminado')),
      );
    } on ExcepcionApi catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text(e.mensaje), backgroundColor: Colors.red),
      );
    }
  }

  void _abrirDetalle(Producto p) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => PantallaProductoDetalle(producto: p)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final estado = ref.watch(productosNotifierProvider);
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
                    'Productos',
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
                  hintText: 'Buscar producto...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (t) =>
                    ref.read(productosNotifierProvider.notifier).buscar(t),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(child: _construirLista(estado, esAdmin)),
          ],
        ),
      ),
    );
  }

  Widget _construirLista(ProductosState estado, bool esAdmin) {
    if (estado.cargando) return const Center(child: CircularProgressIndicator());

    if (estado.error != null && estado.productos.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(estado.error!),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () => ref.read(productosNotifierProvider.notifier).cargar(),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (estado.productos.isEmpty) {
      return const Center(child: Text('No hay productos.'));
    }

    return ListView.builder(
      controller: _scrollCtrl,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
      itemCount: estado.productos.length + (estado.cargandoMas ? 1 : 0),
      itemBuilder: (context, i) {
        if (i >= estado.productos.length) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        final p = estado.productos[i];
        return Card(
          child: ListTile(
            onTap: () => _abrirDetalle(p),
            leading: const CircleAvatar(child: Icon(Icons.inventory_2)),
            title: Text(p.nombre),
            subtitle: Text('${p.categoriaNombre} · Stock: ${p.stock}'),
            trailing: esAdmin
                ? PopupMenuButton<String>(
                    onSelected: (op) {
                      if (op == 'editar') _abrirFormulario(p);
                      if (op == 'eliminar') _confirmarEliminar(p);
                    },
                    itemBuilder: (_) => const [
                      PopupMenuItem(value: 'editar', child: Text('Editar')),
                      PopupMenuItem(value: 'eliminar', child: Text('Eliminar')),
                    ],
                  )
                : Text(
                    p.precioFormateado,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
          ),
        );
      },
    );
  }
}
