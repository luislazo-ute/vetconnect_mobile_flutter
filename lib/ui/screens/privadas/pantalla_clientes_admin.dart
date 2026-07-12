import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errores.dart';
import '../../../domain/entities/cliente.dart';
import '../../providers/cliente_providers.dart';
import 'pantalla_cliente_formulario.dart';

class PantallaClientesAdmin extends ConsumerWidget {
  const PantallaClientesAdmin({super.key});

  Future<void> _editar(BuildContext context, WidgetRef ref, Cliente c) async {
    final telCtrl = TextEditingController(text: c.telefono);
    final dirCtrl = TextEditingController(text: c.direccion);
    final messenger = ScaffoldMessenger.of(context);

    final guardar = await showDialog<bool>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: Text('Editar ${c.username}'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: telCtrl,
                  decoration: const InputDecoration(labelText: 'Teléfono'),
                ),
                TextField(
                  controller: dirCtrl,
                  decoration: const InputDecoration(labelText: 'Dirección'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Cancelar'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Guardar'),
              ),
            ],
          ),
    );

    if (guardar == true) {
      try {
        await ref.read(actualizarClienteUcProvider)(c.id, {
          'telefono': telCtrl.text.trim(),
          'direccion': dirCtrl.text.trim(),
        });
        ref.invalidate(clientesProvider);
        messenger.showSnackBar(
          const SnackBar(content: Text('Cliente actualizado')),
        );
      } on ExcepcionApi catch (e) {
        messenger.showSnackBar(
          SnackBar(content: Text(e.mensaje), backgroundColor: Colors.red),
        );
      }
    }
    telCtrl.dispose();
    dirCtrl.dispose();
  }

  Future<void> _eliminar(BuildContext context, WidgetRef ref, Cliente c) async {
    final messenger = ScaffoldMessenger.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Eliminar cliente'),
            content: Text('¿Eliminar a ${c.username}?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Cancelar'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Eliminar'),
              ),
            ],
          ),
    );
    if (ok != true) return;
    try {
      await ref.read(eliminarClienteUcProvider)(c.id);
      ref.invalidate(clientesProvider);
      messenger.showSnackBar(
        const SnackBar(content: Text('Cliente eliminado')),
      );
    } on ExcepcionApi catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text(e.mensaje), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(clientesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de clientes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Nuevo cliente',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const PantallaClienteFormulario(),
              ),
            ),
          ),
        ],
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (e, _) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('$e'),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () => ref.invalidate(clientesProvider),
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            ),
        data: (clientes) {
          if (clientes.isEmpty) {
            return const Center(child: Text('No hay clientes.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: clientes.length,
            itemBuilder: (context, i) {
              final c = clientes[i];
              return Card(
                child: ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.person_outline)),
                  title: Text(c.username),
                  subtitle: Text('${c.telefono} · ${c.direccion}'),
                  trailing: PopupMenuButton<String>(
                    onSelected:
                        (op) =>
                            op == 'editar'
                                ? _editar(context, ref, c)
                                : _eliminar(context, ref, c),
                    itemBuilder:
                        (_) => const [
                          PopupMenuItem(value: 'editar', child: Text('Editar')),
                          PopupMenuItem(
                            value: 'eliminar',
                            child: Text('Eliminar'),
                          ),
                        ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
