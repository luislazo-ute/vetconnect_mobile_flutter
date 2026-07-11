import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/receta.dart';

class PantallaRecetaDetalle extends ConsumerWidget {
  final Receta receta;
  const PantallaRecetaDetalle({super.key, required this.receta});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textos = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de receta'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('Receta para ${receta.mascotaNombre}',
              style: textos.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          _Campo('Veterinario', receta.veterinarioNombre),
          const SizedBox(height: 8),
          _Campo('Fecha', receta.fecha),
          const SizedBox(height: 8),
          _Campo(
            'Observaciones',
            receta.observaciones?.isNotEmpty == true
                ? receta.observaciones!
                : 'Sin observaciones',
          ),
          if (receta.detalles.isNotEmpty) ...[
            const SizedBox(height: 24),
            Text(
              'Medicamentos',
              style: textos.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...receta.detalles.map(
              (d) => Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        d.medicamento,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text('Dosis: ${d.dosis} · Frecuencia: ${d.frecuencia}'),
                      if (d.duracion != null && d.duracion!.isNotEmpty)
                        Text('Duración: ${d.duracion}'),
                      if (d.observaciones != null && d.observaciones!.isNotEmpty)
                        Text('Obs: ${d.observaciones}'),
                    ],
                  ),
                ),
              ),
            ),
          ],
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
