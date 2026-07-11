import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errores.dart';
import '../../../domain/entities/mascota.dart';
import '../../../domain/entities/producto.dart';
import '../../notifiers/mascotas_notifier.dart';
import '../../notifiers/productos_notifier.dart';
import '../../notifiers/recetas_notifier.dart';
import '../../providers/receta_providers.dart';

class _LineaMed {
  int? productoId;
  String dosis = '';
  String frecuencia = '';
  String duracion = '';
  String observaciones = '';
}

class PantallaRecetaFormulario extends ConsumerStatefulWidget {
  const PantallaRecetaFormulario({super.key});

  @override
  ConsumerState<PantallaRecetaFormulario> createState() => _FormState();
}

class _FormState extends ConsumerState<PantallaRecetaFormulario> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _instruccionesCtrl;
  late final TextEditingController _fechaCtrl;
  int? _mascotaId;
  bool _guardando = false;
  final List<_LineaMed> _detalles = [];

  @override
  void initState() {
    super.initState();
    _instruccionesCtrl = TextEditingController();
    final hoy = DateTime.now();
    _fechaCtrl = TextEditingController(
      text: '${hoy.year}-${hoy.month.toString().padLeft(2, '0')}-'
          '${hoy.day.toString().padLeft(2, '0')}',
    );
  }

  @override
  void dispose() {
    _instruccionesCtrl.dispose();
    _fechaCtrl.dispose();
    super.dispose();
  }

  Future<void> _seleccionarFecha() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      _fechaCtrl.text =
          '${picked.year}-${picked.month.toString().padLeft(2, '0')}-'
          '${picked.day.toString().padLeft(2, '0')}';
    }
  }

  void _agregarDetalle() => setState(() => _detalles.add(_LineaMed()));
  void _removerDetalle(int i) => setState(() => _detalles.removeAt(i));

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    if (_detalles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Agrega al menos un medicamento'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    setState(() => _guardando = true);

    final datos = <String, dynamic>{
      'mascota': _mascotaId,
      'fecha_emision': '${_fechaCtrl.text.trim()}T09:00:00',
      if (_instruccionesCtrl.text.trim().isNotEmpty)
        'instrucciones': _instruccionesCtrl.text.trim(),
    };
    final detalles = _detalles
        .map((d) => <String, dynamic>{
              'producto': d.productoId,
              'dosis': d.dosis.trim(),
              'frecuencia': d.frecuencia.trim(),
              if (d.duracion.trim().isNotEmpty)
                'duracion_dias': int.tryParse(d.duracion.trim()),
              if (d.observaciones.trim().isNotEmpty)
                'observaciones': d.observaciones.trim(),
            })
        .toList();

    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(crearRecetaUcProvider)(datos: datos, detalles: detalles);
      ref.read(recetasNotifierProvider.notifier).cargar();
      if (mounted) {
        Navigator.of(context).pop();
        messenger.showSnackBar(const SnackBar(content: Text('Receta creada')));
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
    final mascotas = ref
        .watch(mascotasNotifierProvider)
        .mascotas
        .where((m) => m.isActive)
        .toList();
    final productos = ref
        .watch(productosNotifierProvider)
        .productos
        .where((p) => p.isActive)
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Nueva receta')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            DropdownButtonFormField<int>(
              initialValue: _mascotaId,
              isExpanded: true,
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
              controller: _fechaCtrl,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Fecha de emisión',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.calendar_today),
              ),
              onTap: _seleccionarFecha,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'La fecha es obligatoria' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _instruccionesCtrl,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Instrucciones (opcional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Medicamentos',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
                TextButton.icon(
                  onPressed: _agregarDetalle,
                  icon: const Icon(Icons.add),
                  label: const Text('Agregar'),
                ),
              ],
            ),
            ..._detalles.asMap().entries.map(
                  (e) => _cardDetalle(e.key, e.value, productos),
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
                  : const Text('Crear receta'),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _cardDetalle(int index, _LineaMed detalle, List<Producto> productos) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<int>(
                    initialValue: detalle.productoId,
                    isExpanded: true,
                    decoration: const InputDecoration(
                      labelText: 'Medicamento',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    items: productos
                        .map((Producto p) => DropdownMenuItem(
                              value: p.id,
                              child: Text(p.nombre, overflow: TextOverflow.ellipsis),
                            ))
                        .toList(),
                    onChanged: (v) => setState(() => detalle.productoId = v),
                    validator: (v) => v == null ? 'Selecciona' : null,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () => _removerDetalle(index),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: detalle.dosis,
                    decoration: const InputDecoration(
                      labelText: 'Dosis',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    onChanged: (v) => detalle.dosis = v,
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Obligatorio' : null,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    initialValue: detalle.frecuencia,
                    decoration: const InputDecoration(
                      labelText: 'Frecuencia',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    onChanged: (v) => detalle.frecuencia = v,
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Obligatorio' : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: detalle.duracion,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Días (opcional)',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    onChanged: (v) => detalle.duracion = v,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    initialValue: detalle.observaciones,
                    decoration: const InputDecoration(
                      labelText: 'Obs. (opcional)',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    onChanged: (v) => detalle.observaciones = v,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
