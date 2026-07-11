import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errores.dart';
import '../../../domain/entities/categoria_producto.dart';
import '../../notifiers/categorias_notifier.dart';
import '../../providers/categoria_providers.dart';

class PantallaCategoriaFormulario extends ConsumerStatefulWidget {
  final CategoriaProducto? categoria;
  const PantallaCategoriaFormulario({super.key, this.categoria});

  @override
  ConsumerState<PantallaCategoriaFormulario> createState() => _FormState();
}

class _FormState extends ConsumerState<PantallaCategoriaFormulario> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nombreCtrl;
  late final TextEditingController _descripcionCtrl;
  bool _isActive = true;
  bool _guardando = false;

  bool get _esEdicion => widget.categoria != null;

  @override
  void initState() {
    super.initState();
    final c = widget.categoria;
    _nombreCtrl = TextEditingController(text: c?.nombre ?? '');
    _descripcionCtrl = TextEditingController(text: c?.descripcion ?? '');
    _isActive = c?.isActive ?? true;
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _descripcionCtrl.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _guardando = true);

    final datos = <String, dynamic>{
      'nombre': _nombreCtrl.text.trim(),
      'descripcion': _descripcionCtrl.text.trim(),
      'is_active': _isActive,
    };

    final messenger = ScaffoldMessenger.of(context);
    try {
      if (_esEdicion) {
        await ref.read(actualizarCategoriaUcProvider)(widget.categoria!.id, datos);
      } else {
        await ref.read(crearCategoriaUcProvider)(datos);
      }
      ref.read(categoriasNotifierProvider.notifier).cargar();
      if (mounted) {
        Navigator.of(context).pop();
        messenger.showSnackBar(
          SnackBar(
            content: Text(_esEdicion ? 'Categoría actualizada' : 'Categoría creada'),
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
        title: Text(_esEdicion ? 'Editar categoría' : 'Nueva categoría'),
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
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Descripción (opcional)',
                border: OutlineInputBorder(),
              ),
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
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(_esEdicion ? 'Guardar cambios' : 'Crear categoría'),
            ),
          ],
        ),
      ),
    );
  }
}
