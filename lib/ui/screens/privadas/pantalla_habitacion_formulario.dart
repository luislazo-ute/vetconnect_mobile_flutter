import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errores.dart';
import '../../../domain/entities/habitacion.dart';
import '../../notifiers/habitaciones_notifier.dart';
import '../../providers/habitacion_providers.dart';

class PantallaHabitacionFormulario extends ConsumerStatefulWidget {
  final Habitacion? habitacion;
  const PantallaHabitacionFormulario({super.key, this.habitacion});

  @override
  ConsumerState<PantallaHabitacionFormulario> createState() => _FormState();
}

class _FormState extends ConsumerState<PantallaHabitacionFormulario> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _codigoCtrl;
  late final TextEditingController _capacidadCtrl;
  late final TextEditingController _precioCtrl;
  late final TextEditingController _observacionesCtrl;
  String? _tipo;
  String _estado = 'disponible';
  bool _isActive = true;
  bool _guardando = false;

  bool get _esEdicion => widget.habitacion != null;

  @override
  void initState() {
    super.initState();
    final h = widget.habitacion;
    _codigoCtrl = TextEditingController(text: h?.codigo ?? '');
    _capacidadCtrl = TextEditingController(text: h?.capacidad.toString() ?? '1');
    _precioCtrl = TextEditingController(text: h?.precioDia ?? '');
    _observacionesCtrl = TextEditingController(text: h?.observaciones ?? '');
    _tipo = (h != null && h.tipo.isNotEmpty) ? h.tipo : null;
    _estado = h?.estado ?? 'disponible';
    _isActive = h?.isActive ?? true;
  }

  @override
  void dispose() {
    _codigoCtrl.dispose();
    _capacidadCtrl.dispose();
    _precioCtrl.dispose();
    _observacionesCtrl.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _guardando = true);

    final datos = <String, dynamic>{
      'codigo': _codigoCtrl.text.trim(),
      'tipo': _tipo ?? '',
      'capacidad': int.parse(_capacidadCtrl.text.trim()),
      'precio_dia': _precioCtrl.text.trim(),
      'estado': _estado,
      'observaciones': _observacionesCtrl.text.trim(),
      'is_active': _isActive,
    };

    final messenger = ScaffoldMessenger.of(context);
    try {
      if (_esEdicion) {
        await ref.read(actualizarHabitacionUcProvider)(
          widget.habitacion!.id,
          datos,
        );
      } else {
        await ref.read(crearHabitacionUcProvider)(datos);
      }
      ref.read(habitacionesNotifierProvider.notifier).cargar();
      if (mounted) {
        Navigator.of(context).pop();
        messenger.showSnackBar(
          SnackBar(
            content: Text(
                _esEdicion ? 'Habitación actualizada' : 'Habitación creada'),
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
        title: Text(_esEdicion ? 'Editar habitación' : 'Nueva habitación'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextFormField(
              controller: _codigoCtrl,
              decoration: const InputDecoration(
                labelText: 'Código',
                hintText: 'Ej: H-101',
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'El código es obligatorio' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _tipo,
              decoration: const InputDecoration(
                labelText: 'Tipo',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'individual', child: Text('Individual')),
                DropdownMenuItem(value: 'compartida', child: Text('Compartida')),
                DropdownMenuItem(value: 'uci', child: Text('UCI')),
              ],
              onChanged: (v) => setState(() => _tipo = v),
              validator: (v) => v == null ? 'Selecciona un tipo' : null,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _capacidadCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Capacidad',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Obligatorio';
                      if (int.tryParse(v.trim()) == null) return 'Inválido';
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _precioCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Precio/día',
                      prefixText: '\$',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Obligatorio';
                      if (double.tryParse(v.trim()) == null) return 'Inválido';
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _estado,
              decoration: const InputDecoration(
                labelText: 'Estado',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'disponible', child: Text('Disponible')),
                DropdownMenuItem(value: 'ocupada', child: Text('Ocupada')),
                DropdownMenuItem(value: 'mantenimiento', child: Text('Mantenimiento')),
              ],
              onChanged: (v) => setState(() => _estado = v ?? 'disponible'),
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
                  : Text(_esEdicion ? 'Guardar cambios' : 'Crear habitación'),
            ),
          ],
        ),
      ),
    );
  }
}
