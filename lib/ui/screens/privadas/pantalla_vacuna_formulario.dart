import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errores.dart';
import '../../../domain/entities/mascota.dart';
import '../../../domain/entities/vacuna.dart';
import '../../notifiers/mascotas_notifier.dart';
import '../../notifiers/vacunas_notifier.dart';
import '../../providers/vacuna_providers.dart';

class PantallaVacunaFormulario extends ConsumerStatefulWidget {
  final Vacuna? vacuna;
  const PantallaVacunaFormulario({super.key, this.vacuna});

  @override
  ConsumerState<PantallaVacunaFormulario> createState() => _FormState();
}

class _FormState extends ConsumerState<PantallaVacunaFormulario> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nombreCtrl;
  late final TextEditingController _fechaCtrl;
  late final TextEditingController _fechaProxCtrl;
  late final TextEditingController _loteCtrl;
  late final TextEditingController _dosisCtrl;
  late final TextEditingController _observacionesCtrl;
  int? _mascotaId;
  bool _isActive = true;
  bool _guardando = false;

  bool get _esEdicion => widget.vacuna != null;

  @override
  void initState() {
    super.initState();
    final v = widget.vacuna;
    _nombreCtrl = TextEditingController(text: v?.nombreVacuna ?? '');
    _fechaCtrl = TextEditingController(text: v?.fechaAplicacion ?? '');
    _fechaProxCtrl = TextEditingController(text: v?.fechaProximaDosis ?? '');
    _loteCtrl = TextEditingController(text: v?.lote ?? '');
    _dosisCtrl = TextEditingController(text: v?.dosis ?? '');
    _observacionesCtrl = TextEditingController(text: v?.observaciones ?? '');
    _mascotaId = v?.mascota;
    _isActive = v?.isActive ?? true;
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _fechaCtrl.dispose();
    _fechaProxCtrl.dispose();
    _loteCtrl.dispose();
    _dosisCtrl.dispose();
    _observacionesCtrl.dispose();
    super.dispose();
  }

  Future<void> _seleccionarFecha(TextEditingController ctrl) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      final formatted =
          '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      ctrl.text = formatted;
    }
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _guardando = true);

    final datos = <String, dynamic>{
      'nombre_vacuna': _nombreCtrl.text.trim(),
      'mascota': _mascotaId,
      'fecha_aplicacion': _fechaCtrl.text.trim(),
      if (_fechaProxCtrl.text.trim().isNotEmpty)
        'fecha_proxima_dosis': _fechaProxCtrl.text.trim(),
      if (_loteCtrl.text.trim().isNotEmpty) 'lote': _loteCtrl.text.trim(),
      if (_dosisCtrl.text.trim().isNotEmpty) 'dosis': _dosisCtrl.text.trim(),
      if (_observacionesCtrl.text.trim().isNotEmpty)
        'observaciones': _observacionesCtrl.text.trim(),
      'is_active': _isActive,
    };

    final messenger = ScaffoldMessenger.of(context);
    try {
      if (_esEdicion) {
        await ref.read(actualizarVacunaUcProvider)(widget.vacuna!.id, datos);
      } else {
        await ref.read(crearVacunaUcProvider)(datos);
      }
      ref.read(vacunasNotifierProvider.notifier).cargar();
      if (mounted) {
        Navigator.of(context).pop();
        messenger.showSnackBar(
          SnackBar(
            content: Text(_esEdicion ? 'Vacuna actualizada' : 'Vacuna registrada'),
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

    return Scaffold(
      appBar: AppBar(
        title: Text(_esEdicion ? 'Editar vacuna' : 'Nueva vacuna'),
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
            const SizedBox(height: 16),
            TextFormField(
              controller: _nombreCtrl,
              decoration: const InputDecoration(
                labelText: 'Nombre de la vacuna',
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'El nombre es obligatorio' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _fechaCtrl,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Fecha de aplicación',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.calendar_today),
              ),
              onTap: () => _seleccionarFecha(_fechaCtrl),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'La fecha es obligatoria' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _fechaProxCtrl,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Próxima dosis (opcional)',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.calendar_today),
              ),
              onTap: () => _seleccionarFecha(_fechaProxCtrl),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _loteCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Lote (opcional)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _dosisCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Dosis (opcional)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _observacionesCtrl,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Observaciones (opcional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Activa'),
              value: _isActive,
              onChanged: (v) => setState(() => _isActive = v),
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
                  : Text(_esEdicion ? 'Guardar cambios' : 'Registrar vacuna'),
            ),
          ],
        ),
      ),
    );
  }
}
