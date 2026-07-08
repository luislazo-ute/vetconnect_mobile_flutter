import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errores.dart';
import '../../../domain/entities/historial.dart';
import '../../notifiers/historiales_notifier.dart';
import '../../providers/cita_providers.dart'; // dropdowns de mascotas y veterinarios
import '../../providers/historial_providers.dart';

/// Formulario para crear o editar un historial médico (DOCTOR/ADMIN).
class PantallaHistorialFormulario extends ConsumerStatefulWidget {
  final Historial? historial;
  const PantallaHistorialFormulario({super.key, this.historial});

  @override
  ConsumerState<PantallaHistorialFormulario> createState() => _State();
}

class _State extends ConsumerState<PantallaHistorialFormulario> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _diagCtrl;
  late final TextEditingController _tratCtrl;
  late final TextEditingController _obsCtrl;
  int? _mascotaId;
  int? _vetId;
  bool _guardando = false;

  bool get _esEdicion => widget.historial != null;

  @override
  void initState() {
    super.initState();
    final h = widget.historial;
    _diagCtrl = TextEditingController(text: h?.diagnostico ?? '');
    _tratCtrl = TextEditingController(text: h?.tratamiento ?? '');
    _obsCtrl = TextEditingController(text: h?.observaciones ?? '');
    _mascotaId = h?.mascota;
    _vetId = h?.veterinario;
  }

  @override
  void dispose() {
    _diagCtrl.dispose();
    _tratCtrl.dispose();
    _obsCtrl.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _guardando = true);
    final datos = {
      'mascota': _mascotaId,
      'veterinario': _vetId,
      'diagnostico': _diagCtrl.text.trim(),
      'tratamiento': _tratCtrl.text.trim(),
      'observaciones': _obsCtrl.text.trim(),
    };
    final messenger = ScaffoldMessenger.of(context);
    try {
      if (_esEdicion) {
        await ref.read(actualizarHistorialUcProvider)(widget.historial!.id, datos);
      } else {
        await ref.read(crearHistorialUcProvider)(datos);
      }
      ref.read(historialesNotifierProvider.notifier).cargar();
      if (mounted) {
        Navigator.of(context).pop();
        messenger.showSnackBar(SnackBar(
            content: Text(_esEdicion ? 'Historial actualizado' : 'Historial creado')));
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
    final mascotas = ref.watch(mascotasTodasProvider);
    final vets = ref.watch(veterinariosTodosProvider);

    return Scaffold(
      appBar: AppBar(title: Text(_esEdicion ? 'Editar historial' : 'Nuevo historial')),
      body: (mascotas.isLoading || vets.isLoading)
          ? const Center(child: CircularProgressIndicator())
          : (mascotas.hasError || vets.hasError)
              ? const Center(child: Text('Error cargando datos'))
              : Form(
                  key: _formKey,
                  child: ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      DropdownButtonFormField<int>(
                        initialValue: _mascotaId,
                        decoration: const InputDecoration(
                            labelText: 'Mascota', border: OutlineInputBorder()),
                        items: mascotas.value!
                            .map((m) => DropdownMenuItem(
                                value: m.id, child: Text(m.nombre)))
                            .toList(),
                        onChanged: (v) => setState(() => _mascotaId = v),
                        validator: (v) => v == null ? 'Selecciona una mascota' : null,
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<int>(
                        initialValue: _vetId,
                        decoration: const InputDecoration(
                            labelText: 'Veterinario', border: OutlineInputBorder()),
                        items: vets.value!
                            .map((vt) => DropdownMenuItem(
                                value: vt.id, child: Text(vt.nombre)))
                            .toList(),
                        onChanged: (v) => setState(() => _vetId = v),
                        validator: (v) => v == null ? 'Selecciona un veterinario' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _diagCtrl,
                        maxLines: 2,
                        decoration: const InputDecoration(
                            labelText: 'Diagnóstico', border: OutlineInputBorder()),
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'El diagnóstico es obligatorio'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _tratCtrl,
                        maxLines: 2,
                        decoration: const InputDecoration(
                            labelText: 'Tratamiento', border: OutlineInputBorder()),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _obsCtrl,
                        maxLines: 3,
                        decoration: const InputDecoration(
                            labelText: 'Observaciones', border: OutlineInputBorder()),
                      ),
                      const SizedBox(height: 24),
                      FilledButton(
                        onPressed: _guardando ? null : _guardar,
                        child: _guardando
                            ? const SizedBox(
                                height: 20, width: 20,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: Colors.white))
                            : Text(_esEdicion ? 'Guardar cambios' : 'Crear historial'),
                      ),
                    ],
                  ),
                ),
    );
  }
}
