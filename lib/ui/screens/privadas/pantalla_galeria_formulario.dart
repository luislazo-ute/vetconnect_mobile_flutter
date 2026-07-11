import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errores.dart';
import '../../../core/imagenes.dart';
import '../../providers/cita_providers.dart';
import '../../providers/galeria_providers.dart';

class PantallaGaleriaFormulario extends ConsumerStatefulWidget {
  const PantallaGaleriaFormulario({super.key});

  @override
  ConsumerState<PantallaGaleriaFormulario> createState() => _GaleriaFormState();
}

class _GaleriaFormState extends ConsumerState<PantallaGaleriaFormulario> {
  final _formKey = GlobalKey<FormState>();
  final _descCtrl = TextEditingController();
  int? _mascotaId;
  String? _fotoRuta;
  bool _guardando = false;

  @override
  void dispose() {
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _guardando = true);
    final datos = {
      'mascota_id': _mascotaId,
      'url': _fotoRuta,
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
                    DropdownButtonFormField<String>(
                      initialValue: _fotoRuta,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: 'Foto',
                        border: OutlineInputBorder(),
                      ),
                      items:
                          fotosDisponibles
                              .map(
                                (f) => DropdownMenuItem(
                                  value: f.ruta,
                                  child: Text(f.etiqueta),
                                ),
                              )
                              .toList(),
                      onChanged: (v) => setState(() => _fotoRuta = v),
                      validator:
                          (v) => v == null ? 'Selecciona una foto' : null,
                    ),
                    if (_fotoRuta != null) ...[
                      const SizedBox(height: 16),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          _fotoRuta!,
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
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
