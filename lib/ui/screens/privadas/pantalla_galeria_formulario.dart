import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

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
  final _descCtrl = TextEditingController();
  int? _mascotaId;
  Uint8List? _imagenBytes;
  bool _guardando = false;

  @override
  void dispose() {
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _elegirImagen(ImageSource origen) async {
    final picker = ImagePicker();
    final XFile? archivo = await picker.pickImage(
      source: origen,
      maxWidth: 1000,
      imageQuality: 70,
    );
    if (archivo == null) return;
    final bytes = await archivo.readAsBytes();
    if (mounted) setState(() => _imagenBytes = bytes);
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    if (_imagenBytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecciona una foto'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    setState(() => _guardando = true);
    final base64Foto = 'data:image/jpeg;base64,${base64Encode(_imagenBytes!)}';
    final datos = {
      'mascota_id': _mascotaId,
      'url': base64Foto,
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
      body: mascotas.isLoading
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
                        items: mascotas.value!
                            .map(
                              (m) => DropdownMenuItem(
                                value: m.id,
                                child: Text(m.nombre),
                              ),
                            )
                            .toList(),
                        onChanged: (v) => setState(() => _mascotaId = v),
                        validator: (v) =>
                            v == null ? 'Selecciona una mascota' : null,
                      ),
                      const SizedBox(height: 20),
                      _selectorFoto(),
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
                        child: _guardando
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

  Widget _selectorFoto() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_imagenBytes != null)
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.memory(
              _imagenBytes!,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          )
        else
          Container(
            height: 160,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.image_outlined, size: 44, color: Colors.grey),
                SizedBox(height: 8),
                Text('Sin foto seleccionada',
                    style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _elegirImagen(ImageSource.gallery),
                icon: const Icon(Icons.photo_library_outlined),
                label: const Text('Galería'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _elegirImagen(ImageSource.camera),
                icon: const Icon(Icons.photo_camera_outlined),
                label: const Text('Cámara'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
