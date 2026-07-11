import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errores.dart';
import '../../../core/imagenes.dart';
import '../../../domain/entities/veterinario.dart';
import '../../notifiers/veterinarios_notifier.dart';
import '../../providers/veterinario_providers.dart';
import 'pantalla_veterinario_formulario.dart';

class PantallaVeterinariosAdmin extends ConsumerStatefulWidget {
  const PantallaVeterinariosAdmin({super.key});

  @override
  ConsumerState<PantallaVeterinariosAdmin> createState() => _State();
}

class _State extends ConsumerState<PantallaVeterinariosAdmin> {
  final _scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollCtrl.addListener(() {
      final pos = _scrollCtrl.position;
      if (pos.pixels >= pos.maxScrollExtent - 200) {
        ref.read(veterinariosNotifierProvider.notifier).cargarMas();
      }
    });
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _abrirFormulario([Veterinario? v]) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PantallaVeterinarioFormulario(veterinario: v),
      ),
    );
  }

  Future<void> _confirmarEliminar(Veterinario v) async {
    final ok = await showDialog<bool>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Eliminar veterinario'),
            content: Text('¿Eliminar a ${v.nombre}?'),
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
    if (ok != true || !mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(eliminarVeterinarioUcProvider)(v.id);
      ref.read(veterinariosNotifierProvider.notifier).cargar();
      messenger.showSnackBar(
        const SnackBar(content: Text('Veterinario eliminado')),
      );
    } on ExcepcionApi catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text(e.mensaje), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final estado = ref.watch(veterinariosNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de veterinarios'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _abrirFormulario(),
          ),
        ],
      ),
      body:
          estado.cargando && estado.veterinarios.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : estado.error != null && estado.veterinarios.isEmpty
              ? Center(child: Text(estado.error!))
              : ListView.builder(
                controller: _scrollCtrl,
                padding: const EdgeInsets.all(16),
                itemCount: estado.veterinarios.length,
                itemBuilder: (context, i) {
                  final v = estado.veterinarios[i];
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: AssetImage(avatarVeterinario(v.nombre)),
                      ),
                      title: Text(v.nombre),
                      subtitle: Text(v.especialidad),
                      trailing: PopupMenuButton<String>(
                        onSelected:
                            (op) =>
                                op == 'editar'
                                    ? _abrirFormulario(v)
                                    : _confirmarEliminar(v),
                        itemBuilder:
                            (_) => const [
                              PopupMenuItem(
                                value: 'editar',
                                child: Text('Editar'),
                              ),
                              PopupMenuItem(
                                value: 'eliminar',
                                child: Text('Eliminar'),
                              ),
                            ],
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
