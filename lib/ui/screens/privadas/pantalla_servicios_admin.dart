import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errores.dart';
import '../../../domain/entities/rol.dart';
import '../../../domain/entities/servicio.dart';
import '../../notifiers/servicios_notifier.dart';
import '../../notifiers/servicios_state.dart';
import '../../providers/producto_providers.dart';
import '../../providers/rol_provider.dart';
import 'pantalla_servicio_detalle.dart';
import 'pantalla_servicio_formulario.dart';

class PantallaServiciosAdmin extends ConsumerStatefulWidget {
  const PantallaServiciosAdmin({super.key});

  @override
  ConsumerState<PantallaServiciosAdmin> createState() =>
      _PantallaServiciosAdminState();
}

class _PantallaServiciosAdminState extends ConsumerState<PantallaServiciosAdmin> {
  final _scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollCtrl.addListener(() {
      final pos = _scrollCtrl.position;
      if (pos.pixels >= pos.maxScrollExtent - 200) {
        ref.read(serviciosNotifierProvider.notifier).cargarMas();
      }
    });
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _abrirFormulario([Servicio? s]) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => PantallaServicioFormulario(servicio: s)),
    );
  }

  void _abrirDetalle(Servicio s) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => PantallaServicioDetalle(servicio: s)),
    );
  }

  Future<void> _confirmarEliminar(Servicio s) async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar servicio'),
        content: Text('¿Seguro que quieres eliminar "${s.nombre}"?'),
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
      await ref.read(eliminarServicioUcProvider)(s.id);
      ref.read(serviciosNotifierProvider.notifier).cargar();
      messenger.showSnackBar(
        const SnackBar(content: Text('Servicio eliminado')),
      );
    } on ExcepcionApi catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text(e.mensaje), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final estado = ref.watch(serviciosNotifierProvider);
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
                    'Servicios',
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
                  hintText: 'Buscar servicio...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (t) =>
                    ref.read(serviciosNotifierProvider.notifier).buscar(t),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(child: _construirLista(estado, esAdmin)),
          ],
        ),
      ),
    );
  }

  Widget _construirLista(ServiciosState estado, bool esAdmin) {
    if (estado.cargando) return const Center(child: CircularProgressIndicator());

    if (estado.error != null && estado.servicios.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(estado.error!),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () => ref.read(serviciosNotifierProvider.notifier).cargar(),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (estado.servicios.isEmpty) {
      return const Center(child: Text('No hay servicios.'));
    }

    return ListView.builder(
      controller: _scrollCtrl,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
      itemCount: estado.servicios.length + (estado.cargandoMas ? 1 : 0),
      itemBuilder: (context, i) {
        if (i >= estado.servicios.length) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        final s = estado.servicios[i];
        return Card(
          child: ListTile(
            onTap: () => _abrirDetalle(s),
            leading: const CircleAvatar(child: Icon(Icons.medical_services_outlined)),
            title: Text(s.nombre),
            subtitle: Text('${s.duracionMinutos} min · ${s.precioFormateado}'),
            trailing: esAdmin
                ? PopupMenuButton<String>(
                    onSelected: (op) {
                      if (op == 'editar') _abrirFormulario(s);
                      if (op == 'eliminar') _confirmarEliminar(s);
                    },
                    itemBuilder: (_) => const [
                      PopupMenuItem(value: 'editar', child: Text('Editar')),
                      PopupMenuItem(value: 'eliminar', child: Text('Eliminar')),
                    ],
                  )
                : Chip(
                    label: Text(s.isActive ? 'Activo' : 'Inactivo'),
                    backgroundColor:
                        s.isActive ? Colors.green[100] : Colors.grey[200],
                  ),
          ),
        );
      },
    );
  }
}
