import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errores.dart';
import '../../notifiers/citas_notifier.dart';
import '../../providers/cita_providers.dart';

class PantallaCitaFormulario extends ConsumerStatefulWidget {
  const PantallaCitaFormulario({super.key});

  @override
  ConsumerState<PantallaCitaFormulario> createState() => _CitaFormState();
}

class _CitaFormState extends ConsumerState<PantallaCitaFormulario> {
  final _formKey = GlobalKey<FormState>();
  final _motivoCtrl = TextEditingController();
  int? _mascotaId;
  int? _vetId;
  DateTime? _fecha;
  TimeOfDay? _hora;
  bool _guardando = false;

  @override
  void dispose() {
    _motivoCtrl.dispose();
    super.dispose();
  }

  String _dd(int n) => n.toString().padLeft(2, '0');

  Future<void> _elegirFecha() async {
    final hoy = DateTime.now();
    final d = await showDatePicker(
      context: context,
      initialDate: hoy,
      firstDate: hoy,
      lastDate: hoy.add(const Duration(days: 365)),
    );
    if (d != null) setState(() => _fecha = d);
  }

  Future<void> _elegirHora() async {
    final t = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (t != null) setState(() => _hora = t);
  }

  Future<void> _agendar() async {
    if (!_formKey.currentState!.validate()) return;
    if (_fecha == null || _hora == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Elige fecha y hora'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    setState(() => _guardando = true);

    final dt = DateTime(
      _fecha!.year,
      _fecha!.month,
      _fecha!.day,
      _hora!.hour,
      _hora!.minute,
    );
    final datos = {
      'mascota': _mascotaId,
      'veterinario': _vetId,
      'fecha': dt.toUtc().toIso8601String(),
      'hora': '${_dd(_hora!.hour)}:${_dd(_hora!.minute)}:00',
      'motivo': _motivoCtrl.text.trim(),
    };

    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(agendarCitaUcProvider)(datos);
      ref.read(citasNotifierProvider.notifier).cargar();
      if (mounted) {
        Navigator.of(context).pop();
        messenger.showSnackBar(const SnackBar(content: Text('Cita agendada')));
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
      appBar: AppBar(title: const Text('Agendar cita')),
      body:
          (mascotas.isLoading || vets.isLoading)
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
                        labelText: 'Mascota',
                        border: OutlineInputBorder(),
                      ),
                      items:
                          mascotas.value!
                              .map(
                                (m) => DropdownMenuItem(
                                  value: m.id,
                                  child: Text(m.nombre),
                                ),
                              )
                              .toList(),
                      onChanged: (v) => setState(() => _mascotaId = v),
                      validator:
                          (v) => v == null ? 'Selecciona una mascota' : null,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<int>(
                      initialValue: _vetId,
                      decoration: const InputDecoration(
                        labelText: 'Veterinario',
                        border: OutlineInputBorder(),
                      ),
                      items:
                          vets.value!
                              .map(
                                (vt) => DropdownMenuItem(
                                  value: vt.id,
                                  child: Text(vt.nombre),
                                ),
                              )
                              .toList(),
                      onChanged: (v) => setState(() => _vetId = v),
                      validator:
                          (v) => v == null ? 'Selecciona un veterinario' : null,
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      onPressed: _elegirFecha,
                      icon: const Icon(Icons.calendar_today),
                      label: Text(
                        _fecha == null
                            ? 'Elegir fecha'
                            : '${_fecha!.year}-${_dd(_fecha!.month)}-${_dd(_fecha!.day)}',
                      ),
                    ),
                    const SizedBox(height: 8),
                    OutlinedButton.icon(
                      onPressed: _elegirHora,
                      icon: const Icon(Icons.access_time),
                      label: Text(
                        _hora == null ? 'Elegir hora' : _hora!.format(context),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _motivoCtrl,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Motivo',
                        border: OutlineInputBorder(),
                      ),
                      validator:
                          (v) =>
                              (v == null || v.trim().isEmpty)
                                  ? 'Escribe el motivo'
                                  : null,
                    ),
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: _guardando ? null : _agendar,
                      child:
                          _guardando
                              ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                              : const Text('Agendar cita'),
                    ),
                  ],
                ),
              ),
    );
  }
}
