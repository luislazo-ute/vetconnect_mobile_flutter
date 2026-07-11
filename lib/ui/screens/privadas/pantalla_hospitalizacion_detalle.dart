import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errores.dart';
import '../../../domain/entities/hospitalizacion.dart';
import '../../../domain/entities/rol.dart';
import '../../providers/hospitalizacion_providers.dart';
import '../../notifiers/hospitalizaciones_notifier.dart';
import '../../providers/rol_provider.dart';

class PantallaHospitalizacionDetalle extends ConsumerWidget {
  final Hospitalizacion hospitalizacion;
  const PantallaHospitalizacionDetalle({
    super.key,
    required this.hospitalizacion,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final esAdmin = ref.watch(rolActualProvider) == Rol.admin;
    final textos = Theme.of(context).textTheme;
    final esHospitalizado = hospitalizacion.activo;
    final colorEstado = esHospitalizado ? Colors.orange : Colors.green;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de hospitalización'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(hospitalizacion.mascotaNombre,
              style: textos.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Chip(
            label: Text(
              hospitalizacion.estadoDisplay,
              style: TextStyle(color: colorEstado, fontWeight: FontWeight.w600),
            ),
            backgroundColor: colorEstado.withValues(alpha: 0.1),
          ),
          const SizedBox(height: 16),
          _Campo('Motivo', hospitalizacion.motivo),
          const SizedBox(height: 16),
          if (hospitalizacion.diagnostico != null) ...[
            _Campo('Diagnóstico', hospitalizacion.diagnostico!),
            const SizedBox(height: 16),
          ],
          Row(
            children: [
              Expanded(child: _Campo('Fecha de ingreso', hospitalizacion.fechaIngreso)),
              const SizedBox(width: 16),
              Expanded(
                child: _Campo(
                  'Fecha de alta',
                  hospitalizacion.fechaAlta ?? '—',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _Campo('Habitación', hospitalizacion.habitacionCodigo),
          const SizedBox(height: 16),
          _Campo(
            'Tratamiento',
            hospitalizacion.tratamiento?.isNotEmpty == true
                ? hospitalizacion.tratamiento!
                : 'Sin tratamiento registrado',
          ),
          if (esHospitalizado && esAdmin) ...[
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => _darAlta(context, ref),
              icon: const Icon(Icons.check_circle),
              label: const Text('Dar de alta'),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.green,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _darAlta(BuildContext context, WidgetRef ref) async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Dar de alta'),
        content: Text(
            '¿Confirmas que "${hospitalizacion.mascotaNombre}" será dada de alta?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('Dar de alta'),
          ),
        ],
      ),
    );
    if (confirmado != true) return;
    if (!context.mounted) return;

    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(actualizarHospitalizacionUcProvider)(
        hospitalizacion.id,
        {'fecha_alta': DateTime.now().toIso8601String()},
      );
      ref.read(hospitalizacionesNotifierProvider.notifier).cargar();
      if (context.mounted) {
        Navigator.of(context).pop();
        messenger.showSnackBar(
          const SnackBar(content: Text('Alta registrada correctamente')),
        );
      }
    } on ExcepcionApi catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text(e.mensaje), backgroundColor: Colors.red),
      );
    }
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
