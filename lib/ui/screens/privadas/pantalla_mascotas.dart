import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errores.dart';
import '../../../domain/entities/mascota.dart';
import '../../../domain/entities/rol.dart';
import '../../notifiers/mascotas_notifier.dart';
import '../../notifiers/mascotas_state.dart';
import '../../providers/mascota_providers.dart';
import '../../providers/rol_provider.dart';
import 'pantalla_mascota_formulario.dart';

/// Lista de mascotas (pestaña Pacientes). Búsqueda + scroll infinito.
/// El botón "Agregar" solo aparece para ADMIN.
class PantallaMascotas extends ConsumerStatefulWidget {
  const PantallaMascotas({super.key});

  @override
  ConsumerState<PantallaMascotas> createState() => _PantallaMascotasState();
}

class _PantallaMascotasState extends ConsumerState<PantallaMascotas> {
  final _scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollCtrl.addListener(() {
      final pos = _scrollCtrl.position;
      if (pos.pixels >= pos.maxScrollExtent - 200) {
        ref.read(mascotasNotifierProvider.notifier).cargarMas();
      }
    });
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  /// Abre el formulario. Si `m` es null → crear; si trae mascota → editar.
  void _abrirFormulario([Mascota? m]) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => PantallaMascotaFormulario(mascota: m)),
    );
  }

  /// Diálogo de confirmación + eliminación (solo lo llama el admin).
  Future<void> _confirmarEliminar(Mascota m) async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar mascota'),
        content: Text('¿Seguro que quieres eliminar a ${m.nombre}?'),
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
    if (confirmado != true) return;
    if (!mounted) return; // el widget pudo desmontarse mientras el diálogo estaba abierto

    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(eliminarMascotaUcProvider)(m.id);
      ref.read(mascotasNotifierProvider.notifier).cargar();
      messenger.showSnackBar(const SnackBar(content: Text('Mascota eliminada')));
    } on ExcepcionApi catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text(e.mensaje), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final estado = ref.watch(mascotasNotifierProvider);
    final esAdmin = ref.watch(rolActualProvider) == Rol.admin;
    final textos = Theme.of(context).textTheme;

    return SafeArea(
      child: Column(
        children: [
          // Encabezado: título + "Agregar" (solo ADMIN).
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 12, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Mascotas',
                    style: textos.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold)),
                if (esAdmin)
                  TextButton.icon(
                    onPressed: () => _abrirFormulario(),
                    icon: const Icon(Icons.add),
                    label: const Text('Agregar'),
                  ),
              ],
            ),
          ),
          // Buscador.
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Buscar mascota...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onSubmitted: (t) =>
                  ref.read(mascotasNotifierProvider.notifier).buscar(t),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(child: _construirLista(estado, esAdmin)),
        ],
      ),
    );
  }

  Widget _construirLista(MascotasState estado, bool esAdmin) {
    if (estado.cargando) {
      return const Center(child: CircularProgressIndicator());
    }
    if (estado.error != null && estado.mascotas.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(estado.error!),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () => ref.read(mascotasNotifierProvider.notifier).cargar(),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }
    if (estado.mascotas.isEmpty) {
      return const Center(child: Text('No hay mascotas.'));
    }
    return ListView.builder(
      controller: _scrollCtrl,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 100), // aire para el nav
      itemCount: estado.mascotas.length + (estado.cargandoMas ? 1 : 0),
      itemBuilder: (context, i) {
        if (i >= estado.mascotas.length) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        final m = estado.mascotas[i];
        return Card(
          child: ListTile(
            leading: const CircleAvatar(child: Icon(Icons.pets)),
            title: Text(m.nombre),
            subtitle: Text('${m.especieDisplay} · ${m.raza} · ${m.pesoTexto}'),
            // Admin: menú Editar/Eliminar. Otros: solo el nombre del dueño.
            trailing: esAdmin
                ? PopupMenuButton<String>(
                    onSelected: (opcion) {
                      if (opcion == 'editar') {
                        _abrirFormulario(m);
                      } else if (opcion == 'eliminar') {
                        _confirmarEliminar(m);
                      }
                    },
                    itemBuilder: (_) => const [
                      PopupMenuItem(value: 'editar', child: Text('Editar')),
                      PopupMenuItem(value: 'eliminar', child: Text('Eliminar')),
                    ],
                  )
                : Text(m.clienteNombre,
                    style: const TextStyle(color: Colors.grey, fontSize: 12)),
          ),
        );
      },
    );
  }
}
