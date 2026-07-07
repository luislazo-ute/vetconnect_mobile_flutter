import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errores.dart';
import '../../../domain/entities/mascota.dart';
import '../../notifiers/mascotas_notifier.dart';
import '../../providers/cliente_providers.dart';
import '../../providers/mascota_providers.dart';

/// Formulario para crear o editar una mascota.
/// Si `mascota` es null → crear; si trae una → editar (precarga).
class PantallaMascotaFormulario extends ConsumerStatefulWidget {
  final Mascota? mascota;
  const PantallaMascotaFormulario({super.key, this.mascota});

  @override
  ConsumerState<PantallaMascotaFormulario> createState() => _FormState();
}

class _FormState extends ConsumerState<PantallaMascotaFormulario> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nombreCtrl;
  late final TextEditingController _razaCtrl;
  late final TextEditingController _pesoCtrl;
  String? _especie;
  int? _clienteId;
  bool _guardando = false;

  bool get _esEdicion => widget.mascota != null;

  // Opciones de especie: (valor que va a la API, texto que ve el usuario).
  static const _especies = [
    ('perro', 'Perro'),
    ('gato', 'Gato'),
    ('ave', 'Ave'),
    ('conejo', 'Conejo'),
    ('otro', 'Otro'),
  ];

  @override
  void initState() {
    super.initState();
    final m = widget.mascota;
    _nombreCtrl = TextEditingController(text: m?.nombre ?? '');
    _razaCtrl = TextEditingController(text: m?.raza ?? '');
    _pesoCtrl = TextEditingController(text: m?.peso?.toString() ?? '');
    _especie = m?.especie;
    _clienteId = m?.cliente;
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _razaCtrl.dispose();
    _pesoCtrl.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _guardando = true);

    // Cuerpo JSON que enviaremos.
    final datos = <String, dynamic>{
      'nombre': _nombreCtrl.text.trim(),
      'especie': _especie,
      'raza': _razaCtrl.text.trim(),
      'cliente': _clienteId,
      if (_pesoCtrl.text.trim().isNotEmpty) 'peso': _pesoCtrl.text.trim(),
    };

    final messenger = ScaffoldMessenger.of(context);
    try {
      if (_esEdicion) {
        await ref.read(actualizarMascotaUcProvider)(widget.mascota!.id, datos);
      } else {
        await ref.read(crearMascotaUcProvider)(datos);
      }
      ref.read(mascotasNotifierProvider.notifier).cargar(); // refresca la lista
      if (mounted) {
        Navigator.of(context).pop();
        messenger.showSnackBar(SnackBar(
          content: Text(_esEdicion ? 'Mascota actualizada' : 'Mascota creada'),
        ));
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
    final clientesAsync = ref.watch(clientesProvider);

    return Scaffold(
      appBar: AppBar(title: Text(_esEdicion ? 'Editar mascota' : 'Nueva mascota')),
      body: clientesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error cargando clientes: $e')),
        data: (clientes) => Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              TextFormField(
                controller: _nombreCtrl,
                decoration: const InputDecoration(
                    labelText: 'Nombre', border: OutlineInputBorder()),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'El nombre es obligatorio'
                    : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _especie,
                decoration: const InputDecoration(
                    labelText: 'Especie', border: OutlineInputBorder()),
                items: _especies
                    .map((e) => DropdownMenuItem(value: e.$1, child: Text(e.$2)))
                    .toList(),
                onChanged: (v) => setState(() => _especie = v),
                validator: (v) => v == null ? 'Selecciona una especie' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _razaCtrl,
                decoration: const InputDecoration(
                    labelText: 'Raza', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _pesoCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    labelText: 'Peso (kg, opcional)', border: OutlineInputBorder()),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return null; // opcional
                  if (double.tryParse(v.trim()) == null) {
                    return 'Peso inválido (usa números, ej. 5.2)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                initialValue: _clienteId,
                decoration: const InputDecoration(
                    labelText: 'Dueño (cliente)', border: OutlineInputBorder()),
                items: clientes
                    .map((c) =>
                        DropdownMenuItem(value: c.id, child: Text(c.username)))
                    .toList(),
                onChanged: (v) => setState(() => _clienteId = v),
                validator: (v) => v == null ? 'Selecciona un cliente' : null,
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _guardando ? null : _guardar,
                child: _guardando
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white))
                    : Text(_esEdicion ? 'Guardar cambios' : 'Crear mascota'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
