import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../notifiers/servicios_notifier.dart';
import '../../notifiers/servicios_state.dart';

/// Pantalla pública: listado de servicios con búsqueda y scroll infinito.
class PantallaServicios extends ConsumerStatefulWidget {
  const PantallaServicios({super.key});

  @override
  ConsumerState<PantallaServicios> createState() => _PantallaServiciosState();
}

class _PantallaServiciosState extends ConsumerState<PantallaServicios> {
  final _scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollCtrl.addListener(_alHacerScroll); // escucha el scroll
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _alHacerScroll() {
    final pos = _scrollCtrl.position;
    // Si falta poco (200px) para el fondo, pide la siguiente página.
    if (pos.pixels >= pos.maxScrollExtent - 200) {
      ref.read(serviciosNotifierProvider.notifier).cargarMas();
    }
  }

  @override
  Widget build(BuildContext context) {
    // watch: reconstruye cuando el estado cambia.
    final estado = ref.watch(serviciosNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Servicios')),
      body: Column(
        children: [
          // --- Buscador ---
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Buscar servicio...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              // Al enviar (Enter): dispara la búsqueda.
              onSubmitted: (texto) =>
                  ref.read(serviciosNotifierProvider.notifier).buscar(texto),
            ),
          ),
          Expanded(child: _construirContenido(estado)),
        ],
      ),
    );
  }

  Widget _construirContenido(ServiciosState estado) {
    // 1) Primera carga.
    if (estado.cargando) {
      return const Center(child: CircularProgressIndicator());
    }
    // 2) Error sin datos.
    if (estado.error != null && estado.servicios.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(estado.error!),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () =>
                  ref.read(serviciosNotifierProvider.notifier).cargar(),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }
    // 3) Vacío.
    if (estado.servicios.isEmpty) {
      return const Center(child: Text('No hay servicios.'));
    }
    // 4) Lista + spinner de "cargando más".
    return ListView.builder(
      controller: _scrollCtrl,
      padding: const EdgeInsets.all(16),
      itemCount: estado.servicios.length + (estado.cargandoMas ? 1 : 0),
      itemBuilder: (context, i) {
        if (i >= estado.servicios.length) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        final servicio = estado.servicios[i];
        return Card(
          child: ListTile(
            leading: const Icon(Icons.medical_services_outlined),
            title: Text(servicio.nombre),
            subtitle: Text(servicio.descripcion),
            trailing: Text(servicio.precioFormateado),
          ),
        );
      },
    );
  }
}
