import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errores.dart';
import '../../../domain/entities/factura.dart';
import '../../../domain/entities/rol.dart';
import '../../notifiers/facturas_notifier.dart';
import '../../notifiers/facturas_state.dart';
import '../../providers/factura_providers.dart';
import '../../providers/rol_provider.dart';
import 'pantalla_factura_detalle.dart';
import 'pantalla_factura_formulario.dart';

class PantallaFacturas extends ConsumerStatefulWidget {
  const PantallaFacturas({super.key});

  @override
  ConsumerState<PantallaFacturas> createState() => _PantallaFacturasState();
}

class _PantallaFacturasState extends ConsumerState<PantallaFacturas> {
  final _scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollCtrl.addListener(() {
      final pos = _scrollCtrl.position;
      if (pos.pixels >= pos.maxScrollExtent - 200) {
        ref.read(facturasNotifierProvider.notifier).cargarMas();
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
      MaterialPageRoute(builder: (_) => const PantallaFacturaFormulario()),
    );
  }

  Future<void> _confirmarEliminar(Factura f) async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar factura'),
        content: Text('¿Seguro que quieres eliminar la factura #${f.id}?'),
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
      await ref.read(eliminarFacturaUcProvider)(f.id);
      ref.read(facturasNotifierProvider.notifier).cargar();
      messenger.showSnackBar(const SnackBar(content: Text('Factura eliminada')));
    } on ExcepcionApi catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text(e.mensaje), backgroundColor: Colors.red),
      );
    }
  }

  void _abrirDetalle(Factura f) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => PantallaFacturaDetalle(facturaId: f.id)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final estado = ref.watch(facturasNotifierProvider);
    final esAdmin = ref.watch(rolActualProvider) == Rol.admin;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Facturas'),
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

  Widget _construirLista(FacturasState estado, bool esAdmin) {
    if (estado.cargando) return const Center(child: CircularProgressIndicator());

    if (estado.error != null && estado.facturas.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(estado.error!),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () => ref.read(facturasNotifierProvider.notifier).cargar(),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (estado.facturas.isEmpty) {
      return const Center(child: Text('No hay facturas.'));
    }

    return ListView.builder(
      controller: _scrollCtrl,
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
      itemCount: estado.facturas.length + (estado.cargandoMas ? 1 : 0),
      itemBuilder: (context, i) {
        if (i >= estado.facturas.length) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        final f = estado.facturas[i];
        return Card(
          child: ListTile(
            onTap: () => _abrirDetalle(f),
            leading: CircleAvatar(
              backgroundColor: f.pagada ? Colors.green[100] : Colors.orange[100],
              child: Icon(
                Icons.receipt_long_outlined,
                color: f.pagada ? Colors.green : Colors.orange,
              ),
            ),
            title: Text('Factura #${f.id} · ${f.clienteUsername}'),
            subtitle: Text('${f.totalFormateado} · ${f.pagada ? 'Pagada' : 'Pendiente'}'),
            trailing: esAdmin
                ? PopupMenuButton<String>(
                    onSelected: (op) {
                      if (op == 'eliminar') _confirmarEliminar(f);
                    },
                    itemBuilder: (_) => const [
                      PopupMenuItem(value: 'eliminar', child: Text('Eliminar')),
                    ],
                  )
                : Icon(
                    f.pagada ? Icons.check_circle : Icons.schedule,
                    color: f.pagada ? Colors.green : Colors.orange,
                  ),
          ),
        );
      },
    );
  }
}
