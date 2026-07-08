import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../notifiers/veterinarios_notifier.dart';
import '../../notifiers/veterinarios_state.dart';

class PantallaEquipo extends ConsumerStatefulWidget {
  const PantallaEquipo({super.key});

  @override
  ConsumerState<PantallaEquipo> createState() => _PantallaEquipoState();
}

class _PantallaEquipoState extends ConsumerState<PantallaEquipo> {
  final _scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollCtrl.addListener(_alHacerScroll);
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _alHacerScroll() {
    final pos = _scrollCtrl.position;
    if (pos.pixels >= pos.maxScrollExtent - 200) {
      ref.read(veterinariosNotifierProvider.notifier).cargarMas();
    }
  }

  @override
  Widget build(BuildContext context) {
    final estado = ref.watch(veterinariosNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Nuestro equipo')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Buscar por nombre o especialidad...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onSubmitted:
                  (texto) => ref
                      .read(veterinariosNotifierProvider.notifier)
                      .buscar(texto),
            ),
          ),
          Expanded(child: _construirContenido(estado)),
        ],
      ),
    );
  }

  Widget _construirContenido(VeterinariosState estado) {
    if (estado.cargando) {
      return const Center(child: CircularProgressIndicator());
    }
    if (estado.error != null && estado.veterinarios.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(estado.error!),
            const SizedBox(height: 12),
            FilledButton(
              onPressed:
                  () =>
                      ref.read(veterinariosNotifierProvider.notifier).cargar(),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }
    if (estado.veterinarios.isEmpty) {
      return const Center(child: Text('No hay veterinarios.'));
    }
    return ListView.builder(
      controller: _scrollCtrl,
      padding: const EdgeInsets.all(16),
      itemCount: estado.veterinarios.length + (estado.cargandoMas ? 1 : 0),
      itemBuilder: (context, i) {
        if (i >= estado.veterinarios.length) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        final vet = estado.veterinarios[i];
        return Card(
          child: ListTile(
            leading: Hero(
              tag: 'vet-${vet.id}',
              child: CircleAvatar(
                child: Text(vet.nombre.isNotEmpty ? vet.nombre[0] : '?'),
              ),
            ),
            title: Text(vet.nombre),
            subtitle: Text('${vet.especialidad}\n${vet.horarioAtencion}'),
            isThreeLine: true,
            onTap: () => context.pushNamed('veterinarioDetalle', extra: vet),
          ),
        );
      },
    );
  }
}
