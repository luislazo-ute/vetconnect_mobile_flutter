import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errores.dart';
import '../../../domain/entities/compra.dart';
import '../../../domain/entities/rol.dart';
import '../../notifiers/compras_notifier.dart';
import '../../notifiers/compras_state.dart';
import '../../providers/compra_providers.dart';
import '../../providers/rol_provider.dart';
import 'pantalla_compra_detalle.dart';
import 'pantalla_compra_formulario.dart';

class PantallaCompras extends ConsumerStatefulWidget {
  const PantallaCompras({super.key});

  @override
  ConsumerState<PantallaCompras> createState() => _PantallaComprasState();
}

class _PantallaComprasState extends ConsumerState<PantallaCompras> {
  final _scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollCtrl.addListener(() {
      final pos = _scrollCtrl.position;
      if (pos.pixels >= pos.maxScrollExtent - 200) {
        ref.read(comprasNotifierProvider.notifier).cargarMas();
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
      MaterialPageRoute(builder: (_) => const PantallaCompraFormulario()),
    );
  }

  Future<void> _confirmarEliminar(Compra c) async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar compra'),
        content: Text('¿Seguro que quieres eliminar la compra #${c.id}?'),
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
      await ref.read(eliminarCompraUcProvider)(c.id);
      ref.read(comprasNotifierProvider.notifier).cargar();
      messenger.showSnackBar(const SnackBar(content: Text('Compra eliminada')));
    } on ExcepcionApi catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text(e.mensaje), backgroundColor: Colors.red),
      );
    }
  }

  void _abrirDetalle(Compra c) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => PantallaCompraDetalle(compraId: c.id)),
    );
  }

  Color _colorEstado(String estado) {
    switch (estado) {
      case 'completada':
        return Colors.green;
      case 'cancelada':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    final estado = ref.watch(comprasNotifierProvider);
    final esAdmin = ref.watch(rolActualProvider) == Rol.admin;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Compras'),
        actions: [
          if (esAdmin)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: _abrirFormulario,
            ),
        ],
      ),
      body: _construirLista(estado, esAdmin),
    );
  }

  Widget _construirLista(ComprasState estado, bool esAdmin) {
    if (estado.cargando) return const Center(child: CircularProgressIndicator());

    if (estado.error != null && estado.compras.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(estado.error!),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () => ref.read(comprasNotifierProvider.notifier).cargar(),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (estado.compras.isEmpty) {
      return const Center(child: Text('No hay compras.'));
    }

    return ListView.builder(
      controller: _scrollCtrl,
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
      itemCount: estado.compras.length + (estado.cargandoMas ? 1 : 0),
      itemBuilder: (context, i) {
        if (i >= estado.compras.length) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        final c = estado.compras[i];
        return Card(
          child: ListTile(
            onTap: () => _abrirDetalle(c),
            leading: const CircleAvatar(child: Icon(Icons.shopping_cart_outlined)),
            title: Text('Compra #${c.id} · ${c.proveedorNombre}'),
            subtitle: Text('${c.totalFormateado} · ${c.estadoDisplay}'),
            trailing: esAdmin
                ? PopupMenuButton<String>(
                    onSelected: (op) {
                      if (op == 'eliminar') _confirmarEliminar(c);
                    },
                    itemBuilder: (_) => const [
                      PopupMenuItem(value: 'eliminar', child: Text('Eliminar')),
                    ],
                  )
                : Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _colorEstado(c.estado).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      c.estadoDisplay,
                      style: TextStyle(
                        color: _colorEstado(c.estado),
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
          ),
        );
      },
    );
  }
}
