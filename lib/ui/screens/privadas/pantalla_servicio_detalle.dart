import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/rol.dart';
import '../../../domain/entities/servicio.dart';
import '../../providers/rol_provider.dart';
import 'pantalla_servicio_formulario.dart';

class PantallaServicioDetalle extends ConsumerWidget {
  final Servicio servicio;
  const PantallaServicioDetalle({super.key, required this.servicio});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final esAdmin = ref.watch(rolActualProvider) == Rol.admin;
    final textos = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del servicio'),
        actions: [
          if (esAdmin)
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => PantallaServicioFormulario(servicio: servicio),
                  ),
                );
              },
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(servicio.nombre, style: textos.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          _Campo('Descripción', servicio.descripcion.isEmpty ? 'Sin descripción' : servicio.descripcion),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _Campo('Precio', servicio.precioFormateado)),
              const SizedBox(width: 16),
              Expanded(child: _Campo('Duración', '${servicio.duracionMinutos} min')),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: servicio.isActive ? Colors.green : Colors.red,
                ),
              ),
              const SizedBox(width: 12),
              Text(servicio.isActive ? 'Activo' : 'Inactivo',
                  style: TextStyle(
                    color: servicio.isActive ? Colors.green : Colors.red,
                    fontWeight: FontWeight.w600,
                  )),
            ],
          ),
        ],
      ),
    );
  }
}

class _Campo extends StatelessWidget {
  final String etiqueta;
  final String valor;
  const _Campo(this.etiqueta, this.valor);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(etiqueta,
            style: TextStyle(
              fontSize: 12,
              color: cs.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            )),
        const SizedBox(height: 4),
        Text(valor, style: const TextStyle(fontSize: 16)),
      ],
    );
  }
}
