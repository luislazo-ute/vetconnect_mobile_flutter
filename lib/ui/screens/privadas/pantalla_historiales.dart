import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/historial.dart';
import '../../../domain/entities/rol.dart';
import '../../notifiers/historiales_notifier.dart';
import '../../notifiers/historiales_state.dart';
import '../../providers/rol_provider.dart';
import 'pantalla_historial_formulario.dart';

/// Lista de historiales médicos. DOCTOR/ADMIN pueden crear y editar.
class PantallaHistoriales extends ConsumerStatefulWidget {
  const PantallaHistoriales({super.key});

  @override
  ConsumerState<PantallaHistoriales> createState() => _State();
}

class _State extends ConsumerState<PantallaHistoriales> {
  final _scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollCtrl.addListener(() {
      final pos = _scrollCtrl.position;
      if (pos.pixels >= pos.maxScrollExtent - 200) {
        ref.read(historialesNotifierProvider.notifier).cargarMas();
      }
    });
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _abrirFormulario([Historial? h]) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => PantallaHistorialFormulario(historial: h)));
  }

  @override
  Widget build(BuildContext context) {
    final estado = ref.watch(historialesNotifierProvider);
    final rol = ref.watch(rolActualProvider);
    final puedeEscribir = rol == Rol.doctor || rol == Rol.admin;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historiales médicos'),
        actions: [
          if (puedeEscribir)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => _abrirFormulario(),
            ),
        ],
      ),
      body: _construir(estado, puedeEscribir),
    );
  }

  Widget _construir(HistorialesState estado, bool puedeEscribir) {
    if (estado.cargando) {
      return const Center(child: CircularProgressIndicator());
    }
    if (estado.error != null && estado.historiales.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(estado.error!),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () => ref.read(historialesNotifierProvider.notifier).cargar(),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }
    if (estado.historiales.isEmpty) {
      return const Center(child: Text('No hay historiales.'));
    }
    return ListView.builder(
      controller: _scrollCtrl,
      padding: const EdgeInsets.all(16),
      itemCount: estado.historiales.length + (estado.cargandoMas ? 1 : 0),
      itemBuilder: (context, i) {
        if (i >= estado.historiales.length) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        final h = estado.historiales[i];
        return Card(
          child: ListTile(
            leading: const CircleAvatar(child: Icon(Icons.description_outlined)),
            title: Text('${h.mascotaNombre} · ${h.fechaCorta}'),
            subtitle: Text(h.diagnostico),
            trailing: puedeEscribir
                ? IconButton(
                    icon: const Icon(Icons.edit_outlined),
                    onPressed: () => _abrirFormulario(h),
                  )
                : null,
          ),
        );
      },
    );
  }
}
