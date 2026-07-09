import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errores.dart';
import '../../../domain/entities/servicio.dart';
import '../../notifiers/servicios_notifier.dart';
import '../../providers/producto_providers.dart';

class PantallaServicioFormulario extends ConsumerStatefulWidget {
  final Servicio? servicio;
  const PantallaServicioFormulario({super.key, this.servicio});

  @override
  ConsumerState<PantallaServicioFormulario> createState() => _FormState();
}

class _FormState extends ConsumerState<PantallaServicioFormulario> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nombreCtrl;
  late final TextEditingController _descripcionCtrl;
  late final TextEditingController _precioCtrl;
  late final TextEditingController _duracionCtrl;
  bool _isActive = true;
  bool _guardando = false;

  bool get _esEdicion => widget.servicio != null;

  @override
  void initState() {
    super.initState();
    final s = widget.servicio;
    _nombreCtrl = TextEditingController(text: s?.nombre ?? '');
    _descripcionCtrl = TextEditingController(text: s?.descripcion ?? '');
    _precioCtrl = TextEditingController(
        text: s != null ? s.precio.toStringAsFixed(2) : '');
    _duracionCtrl =
        TextEditingController(text: s?.duracionMinutos.toString() ?? '30');
    _isActive = s?.isActive ?? true;
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _descripcionCtrl.dispose();
    _precioCtrl.dispose();
    _duracionCtrl.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _guardando = true);

    final datos = <String, dynamic>{
      'nombre': _nombreCtrl.text.trim(),
      'descripcion': _descripcionCtrl.text.trim(),
      'precio': _precioCtrl.text.trim(),
      'duracion_minutos': int.parse(_duracionCtrl.text.trim()),
      'is_active': _isActive,
    };

    final messenger = ScaffoldMessenger.of(context);
    try {
      if (_esEdicion) {
        await ref.read(actualizarServicioUcProvider)(widget.servicio!.id, datos);
      } else {
        await ref.read(crearServicioUcProvider)(datos);
      }
      ref.read(serviciosNotifierProvider.notifier).cargar();
      if (mounted) {
        Navigator.of(context).pop();
        messenger.showSnackBar(
          SnackBar(
            content: Text(_esEdicion ? 'Servicio actualizado' : 'Servicio creado'),
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
    return Scaffold(
      appBar: AppBar(
        title: Text(_esEdicion ? 'Editar servicio' : 'Nuevo servicio'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextFormField(
              controller: _nombreCtrl,
              decoration: const InputDecoration(
                labelText: 'Nombre',
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'El nombre es obligatorio' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descripcionCtrl,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Descripción (opcional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _precioCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Precio',
                prefixText: '\$',
                border: OutlineInputBorder(),
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'El precio es obligatorio';
                if (double.tryParse(v.trim()) == null) return 'Precio inválido';
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _duracionCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Duración (minutos)',
                border: OutlineInputBorder(),
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'La duración es obligatoria';
                if (int.tryParse(v.trim()) == null) return 'Duración inválida';
                return null;
              },
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Activo'),
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
                  : Text(_esEdicion ? 'Guardar cambios' : 'Crear servicio'),
            ),
          ],
        ),
      ),
    );
  }
}
