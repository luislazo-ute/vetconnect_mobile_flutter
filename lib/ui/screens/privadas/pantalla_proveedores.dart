import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errores.dart';
import '../../../domain/entities/proveedor.dart';
import '../../../domain/entities/rol.dart';
import '../../notifiers/proveedores_notifier.dart';
import '../../notifiers/proveedores_state.dart';
import '../../providers/proveedor_providers.dart';
import '../../providers/rol_provider.dart';
import 'pantalla_proveedor_detalle.dart';
import 'pantalla_proveedor_formulario.dart';

class PantallaProveedores extends ConsumerStatefulWidget {
  const PantallaProveedores({super.key});

  @override
  ConsumerState<PantallaProveedores> createState() => _PantallaProveedoresState();
}

class _PantallaProveedoresState extends ConsumerState<PantallaProveedores> {
  final _scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollCtrl.addListener(() {
      final pos = _scrollCtrl.position;
      if (pos.pixels >= pos.maxScrollExtent - 200) {
        ref.read(proveedoresNotifierProvider.notifier).cargarMas();
      }
    });
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _abrirFormulario([Proveedor? p]) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => PantallaProveedorFormulario(proveedor: p)),
    );
  }

  Future<void> _confirmarEliminar(Proveedor p) async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar proveedor'),
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
      await ref.read(eliminarProveedorUcProvider)(p.id);
      ref.read(proveedoresNotifierProvider.notifier).cargar();
      messenger.showSnackBar(
        const SnackBar(content: Text('Proveedor eliminado')),
      );
    } on ExcepcionApi catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text(e.mensaje), backgroundColor: Colors.red),
      );
    }
  }

  void _abrirDetalle(Proveedor p) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => PantallaProveedorDetalle(proveedor: p)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final estado = ref.watch(proveedoresNotifierProvider);
    final esAdmin = ref.watch(rolActualProvider) == Rol.admin;
    final textos = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Proveedores'),
        actions: [
          if (esAdmin)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => _abrirFormulario(),
            ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Buscar proveedor...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (t) =>
                    ref.read(proveedoresNotifierProvider.notifier).buscar(t),
              ),
            ),
            Expanded(child: _construirLista(estado, esAdmin, textos)),
          ],
        ),
      ),
    );
  }

  Widget _construirLista(ProveedoresState estado, bool esAdmin, TextTheme textos) {
    if (estado.cargando) return const Center(child: CircularProgressIndicator());

    if (estado.error != null && estado.proveedores.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(estado.error!),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () => ref.read(proveedoresNotifierProvider.notifier).cargar(),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (estado.proveedores.isEmpty) {
      return const Center(child: Text('No hay proveedores.'));
    }

    return ListView.builder(
      controller: _scrollCtrl,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
      itemCount: estado.proveedores.length + (estado.cargandoMas ? 1 : 0),
      itemBuilder: (context, i) {
        if (i >= estado.proveedores.length) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        final p = estado.proveedores[i];
        return Card(
          child: ListTile(
            onTap: () => _abrirDetalle(p),
            leading: const CircleAvatar(child: Icon(Icons.local_shipping_outlined)),
            title: Text(p.nombre),
            subtitle: Text(p.telefono.isEmpty ? 'Sin teléfono' : p.telefono),
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
                : Icon(
                    p.isActive ? Icons.check_circle : Icons.cancel_outlined,
                    color: p.isActive ? Colors.green : Colors.grey,
                  ),
          ),
        );
      },
    );
  }
}
