import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/vacuna.dart';
import '../../providers/rol_provider.dart';
import 'pantalla_vacuna_formulario.dart';

class PantallaVacunaDetalle extends ConsumerWidget {
  final Vacuna vacuna;
  const PantallaVacunaDetalle({super.key, required this.vacuna});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final puedeGestionar = ref.watch(puedeGestionarClinicaProvider);
    final textos = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de vacuna'),
        actions: [
          if (puedeGestionar)
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => PantallaVacunaFormulario(vacuna: vacuna),
                  ),
                );
              },
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(vacuna.nombreVacuna,
              style: textos.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          _Campo('Mascota', vacuna.mascotaNombre),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _Campo('Fecha de aplicación', vacuna.fechaAplicacion)),
              const SizedBox(width: 16),
              Expanded(
                child: _Campo(
                  'Próxima dosis',
                  vacuna.fechaProximaDosis ?? 'Sin programar',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _Campo('Lote', vacuna.lote ?? 'N/D'),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _Campo('Dosis', vacuna.dosis ?? 'N/D'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _Campo(
            'Observaciones',
            vacuna.observaciones?.isNotEmpty == true
                ? vacuna.observaciones!
                : 'Sin observaciones',
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _IndicadorEstado(activo: vacuna.isActive),
              const SizedBox(width: 12),
              Text(
                vacuna.isActive ? 'Activa' : 'Inactiva',
                style: TextStyle(
                  color: vacuna.isActive ? Colors.green : Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
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

class _IndicadorEstado extends StatelessWidget {
  final bool activo;
  const _IndicadorEstado({required this.activo});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: activo ? Colors.green : Colors.red,
      ),
    );
  }
}
