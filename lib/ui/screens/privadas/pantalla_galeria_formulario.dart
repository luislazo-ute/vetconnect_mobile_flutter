import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errores.dart';
import '../../providers/cita_providers.dart';
import '../../providers/galeria_providers.dart';

class PantallaGaleriaFormulario extends ConsumerStatefulWidget {
  const PantallaGaleriaFormulario({super.key});

  @override
  ConsumerState<PantallaGaleriaFormulario> createState() => _GaleriaFormState();
}

class _GaleriaFormState extends ConsumerState<PantallaGaleriaFormulario> {
  final _formKey = GlobalKey<FormState>();
  final _urlCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  int? _mascotaId;
  bool _guardando = false;

  @override
  void dispose() {
    _urlCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _guardando = true);
    final datos = {
      'mascota_id': _mascotaId,
      'url': _urlCtrl.text.trim(),
      'descripcion': _descCtrl.text.trim(),
    };
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(crearFotoUcProvider)(datos);
      ref.invalidate(galeriaProvider);
      if (mounted) {
        Navigator.of(context).pop();
        messenger.showSnackBar(const SnackBar(content: Text('Foto agregada')));
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

    return Scaffold(
      appBar: AppBar(title: const Text('Agregar foto')),
      body:
          mascotas.isLoading
              ? const Center(child: CircularProgressIndicator())
              : mascotas.hasError
              ? const Center(child: Text('Error cargando mascotas'))
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
                    TextFormField(
                      controller: _urlCtrl,
                      decoration: const InputDecoration(
                        labelText: 'URL de la foto',
                        border: OutlineInputBorder(),
                      ),
                      validator:
                          (v) =>
                              (v == null || v.trim().isEmpty)
                                  ? 'Ingresa la URL de la imagen'
                                  : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Descripción',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: _guardando ? null : _guardar,
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
                              : const Text('Agregar foto'),
                    ),
                  ],
                ),
              ),
    );
  }
}
