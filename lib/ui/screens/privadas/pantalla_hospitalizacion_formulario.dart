import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errores.dart';
import '../../../domain/entities/habitacion.dart';
import '../../../domain/entities/hospitalizacion.dart';
import '../../../domain/entities/mascota.dart';
import '../../notifiers/habitaciones_notifier.dart';
import '../../notifiers/hospitalizaciones_notifier.dart';
import '../../notifiers/mascotas_notifier.dart';
import '../../providers/hospitalizacion_providers.dart';

class PantallaHospitalizacionFormulario extends ConsumerStatefulWidget {
  final Hospitalizacion? hospitalizacion;
  const PantallaHospitalizacionFormulario({super.key, this.hospitalizacion});

  @override
  ConsumerState<PantallaHospitalizacionFormulario> createState() => _FormState();
}

class _FormState extends ConsumerState<PantallaHospitalizacionFormulario> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _motivoCtrl;
  late final TextEditingController _diagnosticoCtrl;
  late final TextEditingController _observacionesCtrl;
  int? _mascotaId;
  int? _habitacionId;
  bool _guardando = false;

  bool get _esEdicion => widget.hospitalizacion != null;
  bool get _esAlta => widget.hospitalizacion?.estado == 'alta';

  @override
  void initState() {
    super.initState();
    final h = widget.hospitalizacion;
    _motivoCtrl = TextEditingController(text: h?.motivo ?? '');
    _diagnosticoCtrl = TextEditingController(text: h?.diagnostico ?? '');
    _observacionesCtrl = TextEditingController(text: h?.tratamiento ?? '');
    _mascotaId = h?.mascota;
    _habitacionId = h?.habitacion;
  }

  @override
  void dispose() {
    _motivoCtrl.dispose();
    _diagnosticoCtrl.dispose();
    _observacionesCtrl.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _guardando = true);

    final datos = <String, dynamic>{
      'mascota': _mascotaId,
      'habitacion': _habitacionId,
      'motivo': _motivoCtrl.text.trim(),
      if (!_esEdicion) 'fecha_ingreso': DateTime.now().toIso8601String(),
      if (_diagnosticoCtrl.text.trim().isNotEmpty)
        'diagnostico': _diagnosticoCtrl.text.trim(),
      if (_observacionesCtrl.text.trim().isNotEmpty)
        'tratamiento': _observacionesCtrl.text.trim(),
    };

    final messenger = ScaffoldMessenger.of(context);
    try {
      if (_esEdicion) {
        await ref.read(actualizarHospitalizacionUcProvider)(
          widget.hospitalizacion!.id,
          datos,
        );
      } else {
        await ref.read(crearHospitalizacionUcProvider)(datos);
      }
      ref.read(hospitalizacionesNotifierProvider.notifier).cargar();
      if (mounted) {
        Navigator.of(context).pop();
        messenger.showSnackBar(
          SnackBar(
            content: Text(
              _esEdicion ? 'Hospitalización actualizada' : 'Ingreso registrado',
            ),
          ),
        );
      }
    } on ExcepcionApi catch (e) {
      if (mounted) setState(() => _guardando = false);
      messenger.showSnackBar(
        SnackBar(content: Text(e.mensaje), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final mascotasState = ref.watch(mascotasNotifierProvider);
    final mascotas = mascotasState.mascotas.where((m) => m.isActive).toList();
    final habitacionesState = ref.watch(habitacionesNotifierProvider);
    final habitaciones = habitacionesState.habitaciones
        .where((h) => h.disponible && h.isActive)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(_esEdicion ? 'Editar hospitalización' : 'Nuevo ingreso'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            DropdownButtonFormField<int>(
              initialValue: _mascotaId,
              decoration: const InputDecoration(
                labelText: 'Mascota',
                border: OutlineInputBorder(),
              ),
              items: mascotas
                  .map((Mascota m) => DropdownMenuItem(
                        value: m.id,
                        child: Text(m.nombre),
                      ))
                  .toList(),
              onChanged: (v) => setState(() => _mascotaId = v),
              validator: (v) => v == null ? 'Selecciona una mascota' : null,
            ),
            if (_esAlta) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline, size: 18),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Esta hospitalización ya fue dada de alta.',
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 16),
            TextFormField(
              controller: _motivoCtrl,
              decoration: const InputDecoration(
                labelText: 'Motivo',
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'El motivo es obligatorio' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _diagnosticoCtrl,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Diagnóstico (opcional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              initialValue: _habitacionId,
              decoration: const InputDecoration(
                labelText: 'Habitación',
                border: OutlineInputBorder(),
              ),
              items: habitaciones
                  .map((Habitacion h) => DropdownMenuItem(
                        value: h.id,
                        child: Text('${h.codigo} - ${h.tipoDisplay}'),
                      ))
                  .toList(),
              onChanged: (v) => setState(() => _habitacionId = v),
              validator: (v) =>
                  v == null ? 'Selecciona una habitación' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _observacionesCtrl,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Tratamiento (opcional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _guardando ? null : _guardar,
              child: _guardando
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : Text(_esEdicion ? 'Guardar cambios' : 'Registrar ingreso'),
            ),
          ],
        ),
      ),
    );
  }
}
